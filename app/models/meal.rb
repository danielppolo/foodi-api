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
                   if latitude.present? && longitude.present?
                     geocoded.near([latitude, longitude], radius, select: select)
                   end
                 }

  scope :category, lambda { |category_id = nil|
    if category_id.present?
      joins(:meal_categories)
        .where(meal_categories: { category_id: category_id })
    end
  }

  scope :price, lambda { |max_price|
    where('price_cents < ?', max_price * 100)
  }

  scope :restaurant, lambda { |restaurant_id = nil|
    where(restaurant_id: restaurant_id)  if restaurant_id.present?
  }

  scope :beverages, lambda { |bool = nil|
    where(is_beverage: bool) unless bool.nil?
  }

  scope :vegan, lambda { |bool = nil|
    where(is_vegan: bool) unless bool.nil?
  }

  scope :vegetarian, lambda { |bool = nil|
    where(is_vegetarian: bool) unless bool.nil?
  }

  scope :randomize, lambda {
    order(Arel.sql('RANDOM()'))
  }

  scope :available, lambda { |now = Time.now|
    joins(restaurant: [:opening_times])
      .where('opening_times.start_time <= ?
              AND opening_times.end_time >= ?
              AND opening_times.weekday = ?',
             now + now.gmt_offset,
             now + now.gmt_offset,
             now.wday)
  }

  scope :categories, lambda { |limit = 100|
    Category
      .distinct
      .take(limit)
  }

  scope :nearby_categories, lambda { |latitude:, longitude:, radius:|
    Category
      .select('subquery.name, subquery.id, COUNT(subquery.id) AS uniq_count')
      .group('subquery.name, subquery.id')
      .order(uniq_count: :desc) # TODO: Return random where uniq_count > X
      .from(
        nearby(
          latitude: latitude,
          longitude: longitude,
          radius: radius,
          select: 'categories.id, categories.name'
        ).joins(:categories),
        :subquery
      )
  }

  def available?(now = Time.now)
    joins(restaurant: [:opening_times])
      .where('opening_times.start_time <= ?
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
