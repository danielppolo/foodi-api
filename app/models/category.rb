class Category < ApplicationRecord
  validates :name, presence: true, uniqueness: true, format: { with: /[a-z]+/,
                                                               message: 'only allows downncase letters' }

  has_many :restaurant_categories
  has_many :restaurants, through: :restaurant_categories
end
