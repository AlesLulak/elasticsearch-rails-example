class Email < ActiveRecord::Base
  belongs_to :person, touch: true
  has_many :comments, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
