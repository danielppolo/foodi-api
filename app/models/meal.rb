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
    restaurant.has_delivery
  end

  def address
    restaurant?.address
  end

  def self.categories; end

  def self.set_categories; end

  def self.nearby_categories(limit:, cookies:, radius:); end

  def self.filter_by_location(latitude:, longitude:, radius:); end

  def self.filter_by_cuisine; end

  def self.filter_by_price; end

  def self.from(restaurant)
    restaurant.meals
  end

  def self.filter_by_time; end
end
