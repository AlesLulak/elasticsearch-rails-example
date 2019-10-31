require "elasticsearch/model"

class Person < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  has_many :emails, dependent: :destroy

  validates :firstname, presence: true
  validates :lastname, presence: true

  scope :excluded, -> { where(excluded: true) }

  settings "analysis": {
    "filter": {
      "autocomplete_filter": {
        "type": "edge_ngram",
        "min_gram": 2,
        "max_gram": 10,
      },
    },
    "analyzer": {
      "person_analyzer": {
        "type": "custom",
        "tokenizer": "standard",
        "filter": ["asciifolding", "lowercase"],
      },
      "ngram_analyzer": {
        "type": "custom",
        "tokenizer": "standard",
        "filter": ["asciifolding", "lowercase", "autocomplete_filter"],
      },
    },
  }

  mappings do
    indexes :firstname, type: "text", analyzer: "ngram_analyzer", search_analyzer: "person_analyzer"
    indexes :lastname, type: "text", analyzer: "ngram_analyzer", search_analyzer: "person_analyzer"
    indexes :excluded, type: "boolean"

    indexes :emails, type: :object do # !! important
      indexes :email, type: "text", analyzer: "ngram_analyzer", search_analyzer: "person_analyzer"
    end
  end

  def self.index_json
    {
      only: [:firstname, :lastname, :excluded, :emails],
      include: {
        emails: { only: :email },
      },
    }
  end

  def as_indexed_json(options = nil)
    self.as_json(Person.index_json)
  end

  def fullname
    "#{self.firstname} #{self.lastname}"
  end
end
