class RestaurantCategory < ApplicationRecord
  validates :restaurant, presence: true
  validates :category, presence: true

  belongs_to :restaurant
  belongs_to :category
end
