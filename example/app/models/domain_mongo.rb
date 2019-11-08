class DomainMongo
  include Mongoid::Document
  store_in collection: "domains"

  field :domain, type: String
  field :count, type: Integer

  validates :domain, uniqueness: true
end