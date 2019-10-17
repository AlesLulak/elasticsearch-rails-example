require "elasticsearch/model"

class Person < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  # self.__elasticsearch__.index_name = "person"

  settings "analysis": {
    "analyzer": {
      "person_analyzer": {
        "type": "custom",
        "tokenizer": "standard",
        "filter": ["asciifolding", "lowercase"],
      },
    },
  }

  mapping do
    indexes :firstname, type: "text", analyzer: "person_analyzer"
    indexes :lastname, type: "text", analyzer: "person_analyzer"
    indexes :excluded, type: "boolean"
  end

  def self.find_by_fulltext(q)
    query = Jbuilder.encode do |json|
      json.query do
        json.bool do
          json.must do
            json.child! do
              json.term do
                json.excluded false
              end
            end
            json.child! do
              json.bool do
                json.should {
                  json.child! do
                    json.match do
                      json.firstname { json.query q }
                    end
                  end
                  json.child! do
                    json.match do
                      json.lastname { json.query q }
                    end
                  end
                }
              end
            end
          end
        end
      end
    end

    # byebug

    result = Person.search(query)
    Person.where(id: result.results.map(&:_id)).order("firstname ASC")
  end

  def as_indexed_json(options = nil)
    self.as_json(only: [:firstname, :lastname, :excluded])
  end
end
