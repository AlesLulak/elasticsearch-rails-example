class Email < ActiveRecord::Base
  belongs_to :person, touch: true
  has_many :comments, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  after_validation :associate_with_mongo

  private 

  def associate_with_mongo
    EmailMongo.create(address: self.email, count: 0)
  end
end
