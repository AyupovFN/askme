class Question < ApplicationRecord
  belongs_to :user
  validates :text, :user,  presence: true
  validates :username, length: { maximum: 255, too_long: "%{count} characters is the maximum allowed" }
end
