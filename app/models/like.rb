class Like < ApplicationRecord
  belongs_to :meal
  belongs_to :user

  validates :meal, presence: true
  validates :user, presence: true
end
