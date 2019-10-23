require "elasticsearch/model"

class Person < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  has_many :emails, dependent: :destroy

  validates :firstname, presence: true
  validates :lastname, presence: true

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

  # def self.find_by_fulltext(q)
  # query = {
  #   "query": {
  #     "bool": {
  #       "must": [
  #         {
  #           "term": {
  #             "excluded": false,
  #           },
  #         },
  #         {
  #           "multi_match": {
  #             "query": q,
  #             "fields": [
  #               "firstname",
  #               "lastname",
  #               "emails.email",
  #             ],
  #           },
  #         },
  #       ],
  #     },
  #   },
  # }.as_json
  #   result = Person.search(query)
  #   Person.where(id: result.results.map(&:_id)).limit(5).order("firstname ASC")
  # end

  # Set separately to call also for json
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
end
