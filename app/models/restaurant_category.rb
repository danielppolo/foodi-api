class RestaurantCategory < ApplicationRecord
  validates :restaurant, presence: true
  validates :category, presence: true

  belongs_to :restaurant
  belongs_to :category

  def to_s
    "#{restaurant.name} <=> #{category.name}"
  end
end
