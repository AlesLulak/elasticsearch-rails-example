require "elasticsearch/model"

class Person < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  settings "analysis": {
    "filter": {
      "autocomplete_filter": {
        "type": "edge_ngram",
        "min_gram": 3,
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

  mapping do
    indexes :firstname, type: "text", analyzer: "ngram_analyzer", search_analyzer: "person_analyzer"
    indexes :lastname, type: "text", analyzer: "ngram_analyzer", search_analyzer: "person_analyzer"
    indexes :excluded, type: "boolean"
  end

  def self.find_by_fulltext(q)
    query = {
      "query": {
        "bool": {
          "must": [
            {
              "term": {
                "excluded": false,
              },
            },
            {
              "multi_match": {
                "query": q,
                "fields": [
                  "firstname",
                  "lastname",
                ],
              },
            },
          ],
        },
      },
    }.as_json

    result = Person.search(query)
    Person.where(id: result.results.map(&:_id)).limit(5).order("firstname ASC")
  end

  def as_indexed_json(options = nil)
    self.as_json(only: [:firstname, :lastname, :excluded])
  end
end
