class EmailMongo
  include Mongoid::Document
  store_in collection: "emails"

  field :address, type: String
  field :count, type: Integer

  scope :has_some, ->{ where(:count.gt => 0) }

  validates :address, uniqueness: true
end