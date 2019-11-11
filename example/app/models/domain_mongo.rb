class DomainMongo
  include Mongoid::Document
  store_in collection: "domains"

  field :domain, type: String
  field :count, type: Integer

  scope :has_some, ->{ where(:count.gt => 0) }

  validates :domain, uniqueness: true
end