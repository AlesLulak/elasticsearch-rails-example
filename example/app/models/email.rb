class Email < ActiveRecord::Base
  belongs_to :person, touch: true

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
