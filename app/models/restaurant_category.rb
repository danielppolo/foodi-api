class RestaurantCategory < ApplicationRecord
  validates :restaurant, presence: true
  validates :category, presence: true, uniqueness: { scope: :restaurant,
                                                     message: 'should happen once per restaurant' }

  belongs_to :restaurant
  belongs_to :category

  def to_s
    "#{restaurant.name} <=> #{category.name}"
  end
end
