class Meal < ApplicationRecord
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
  has_many :opening_times, through: :restaurant
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

  def available?(now = Time.now)
    Meal
      .joins(:opening_times)
      .where('
            opening_times.start <= ?
            AND opening_times.end >= ?
            AND opening_times.weekday = ?
            AND meals.id = ?',
             now + now.gmt_offset,
             now + now.gmt_offset,
             now.wday,
             id)
      .exists?
  end

  def delivery?
    restaurant.has_delivery
  end

  def address
    restaurant?.address
  end

  def self.categories
    Category
      .joins(:meal_categories)
      .distinct
      .pluck(:name)
  end

  def self.nearby_categories(latitude:, longitude:, radius:)
    geocoded
      .near([latitude, longitude], radius, select: 'categories.name')
      .joins(:categories)
      .map(&:name)
  end

  scope :nearby, lambda { |latitude:, longitude:, radius:, select: nil|
    geocoded.near([latitude, longitude], radius, select: select)
  }

  scope :by_category, lambda { |category|
    where(category: category)
  }

  scope :by_price, lambda { |max_price|
    where('price_cents < ?', max_price * 100)
  }

  scope :available, lambda { |now = Time.now|
    joins(:opening_times)
      .where('
      opening_times.start <= ?
      AND opening_times.end >= ?
      AND opening_times.weekday = ?',
             now + now.gmt_offset,
             now + now.gmt_offset,
             now.wday)
  }

  def self.from(restaurant)
    restaurant.meals
  end
end
