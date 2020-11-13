class Meal < ApplicationRecord
  after_create { Meal.set_categories }

  validates :price_cents, presence: true
  validates :name, presence: true, uniqueness: { scope: :restaurant }
  validates :description, presence: true
  validates :image, presence: true
  validates :restaurant, presence: true
  validates :preparation_time,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than: 0
            }
  # validates :has_delivery, presence: true

  geocoded_by :address

  belongs_to :restaurant
  has_many :portions
  has_many :ingredients, through: :portions
  has_many :restaurant_categories, through: :restaurant
  has_many :meal_categories, dependent: :destroy
  has_many :categories, through: :meal_categories
  has_one_attached :image

  monetize :price_cents,
           allow_nil: true,
           numericality: {
             greater_than_or_equal_to: 0,
             less_than_or_equal_to: 10_000
           }

  def available?
    restaurant.open?
  end

  def delivery?
    restaurant.delivery
  end

  def address
    restaurant?.address
  end

  def self.categories; end

  def self.set_categories; end

  def self.nearby_categories(limit:, cookies:, radius:)
    # TODO:
    # categories = []
    # Restaurant.near([cookies[:lat].to_f, cookies[:lng].to_f], search_radius).each do |restaurant|
    #   restaurant.meals.each do |meal|
    #     meal.category.split(" ").each do |category|
    #       categories << category if category.length > 3
    #     end
    #   end
    # end
    # counts = Hash.new(0)
    # categories.each { |word| counts[word] += 1 }
    # counts.sort_by { |_key, value| value }.reverse.to_h.keys.first(limit)
  end

  def self.filter_by_location(latitude:, longitude:, radius:)
    nearby_restaurants = Restaurant.filter_by_location(
      latitude: latitude,
      longitude: longitude,
      radius: radius
    )
    nearby_restaurants.map(&:meals).flatten
  end

  def self.filter_by_cuisine
    # TODO:
    # Meal.where()
  end

  def self.filter_by_price
    # TODO:
    # Meal.where()
  end

  def self.filter_by_restaurant
    # TODO:
    restaurant.meals
  end

  def self.filter_by_time
    # TODO:
    # Meal.where()
  end
end
