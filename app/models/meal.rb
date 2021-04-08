class Meal < ApplicationRecord
  enum popularity: %i[low medium high very_high]

  validates :price_cents,
            presence: true,
            numericality: {
              greater_than: 0
            }
  validates :name,
            presence: true,
            uniqueness: {
              scope: :restaurant,
              message: 'already exists in Restaurant'
            }
  validates :description,
            presence: true
  # length: {
  #   minimum: 20,
  #   message: 'must be larger than 20 characters'
  # }
  # validates :image, presence: true
  validates :external_image_url, presence: true

  validates :restaurant, presence: true
  validates :latitude,
            presence: true,
            inclusion: {
              in: -90..90,
              message: '%<value> is not a valid latitude'
            }
  validates :longitude,
            presence: true,
            inclusion: {
              in: -180..180,
              message: '%<value> is not a valid longitude'
            }
  validates :preparation_time,
            presence: true
  # numericality: {
  #   only_integer: true,
  #   greater_than: 0
  # }
  validates :quantity,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than: 0
            }

  geocoded_by :address

  has_many :likes, dependent: :destroy
  belongs_to :restaurant
  has_many :restaurant_categories, through: :restaurant
  has_many :opening_times, through: :restaurant
  has_many :portions, dependent: :destroy
  has_many :ingredients, through: :portions
  has_many :meal_categories, dependent: :destroy
  has_many :categories, through: :meal_categories
  # has_one_attached :image

  monetize :price_cents,
           allow_nil: false,
           numericality: {
             greater_than: 0,
             less_than_or_equal_to: 10_000
           }

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
              opening_times.start_time <= ?
              AND opening_times.end_time >= ?
              AND opening_times.weekday = ?',
             now + now.gmt_offset,
             now + now.gmt_offset,
             now.wday)
  }

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

  def self.from(restaurant)
    restaurant.meals
  end

  def available?(now = Time.now)
    Meal
      .joins(:opening_times)
      .where('
            opening_times.start_time <= ?
            AND opening_times.end_time >= ?
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

  def rate(new_rating)
    total = ((number_of_ratings * rating) + new_rating) / (number_of_ratings + 1).to_f
    update(
      number_of_ratings: number_of_ratings + 1,
      rating: total
    )
    total
  end

  def to_s
    name
  end
end
