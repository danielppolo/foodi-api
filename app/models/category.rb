class Category < ApplicationRecord
  validates :name,
            presence: true,
            uniqueness: true,
            format: {
              with: /[a-z]+/,
              message: 'only accept lowercase letters'
            }

  has_many :restaurant_categories, dependent: :destroy
  has_many :restaurants, through: :restaurant_categories
  has_many :meal_categories, dependent: :destroy
  has_many :meals, through: :meal_categories
end
