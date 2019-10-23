class Comment < ActiveRecord::Base
  belongs_to :email, touch: true
  validates :content, presence: true
end
