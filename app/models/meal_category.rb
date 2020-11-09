class MealCategory < ApplicationRecord
  validates :meal, presence: true
  validates :category, presence: true

  belongs_to :meal
  belongs_to :category
end
