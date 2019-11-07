class EmailMongo
  include Mongoid::Document
  store_in collection: "emails"

  field :address, type: String
  field :count, type: Integer

  validates :address, uniqueness: true
end