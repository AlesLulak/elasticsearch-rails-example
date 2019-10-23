class Comment < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :email, touch: true
  validates :content, presence: true

  settings "analysis": {
    "analyzer": {
      "comment_analyzer": {
        "type": "custom",
        "tokenizer": "standard",
        "filter": ["asciifolding", "lowercase"],
      },
    },
  }

  mappings do
    indexes :content, type: "text", analyzer: "comment_analyzer"
  end

  # Set separately to call also for json
  def self.index_json
    {
      only: [:content],
    }
  end

  def as_indexed_json(options = nil)
    self.as_json(Comment.index_json)
  end
end
