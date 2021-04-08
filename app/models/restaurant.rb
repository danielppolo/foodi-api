require 'date'
require 'json'

class Restaurant < ApplicationRecord
  # enum serving_methods: %i[in_place delivery]
  enum popularity: %i[low medium high very_high]
  enum store_type: %i[restaurant dark_kitchen]

  validates :name, presence: true, uniqueness: { scope: :address }
  validates :address, presence: true
  validates :friendly_schedule, presence: true, schedule: true
  # validates :logotype, presence: true
  validates :external_image_url, presence: true
  validates :rating, inclusion: { in: 0..5 }
  validates :has_delivery, presence: true

  has_many :meals, dependent: :destroy
  has_many :opening_times, dependent: :destroy
  has_many :restaurant_categories, dependent: :destroy
  has_many :categories, through: :restaurant_categories
  # has_one_attached :image
  # has_one_attached :logotype

  geocoded_by :address

  after_validation :geocode, if: :will_save_change_to_address?
  after_save :serialize_schedule
  after_save :geocode_meals

  scope :nearby, lambda { |latitude:, longitude:, radius:, select: nil|
    geocoded.near([latitude, longitude], radius, select: select)
  }

  scope :available, lambda { |now = Time.now|
    joins(:opening_times)
      .where('
      opening_times.start_time <= ?
      AND opening_times.end_tieme >= ?
      AND opening_times.weekday = ?',
             now + now.gmt_offset,
             now + now.gmt_offset,
             now.wday)
  }

  def self.categories
    Category
      .joins(:restaurant_categories)
      .distinct
      .pluck(:name)
  end

  def coordinates
    [latitude, longitude]
  end

  def available?(now = Time.now)
    Restaurant
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

  def eta
    distance_to([latitude, longitude]) * 12 # Median pace
  end

  def distance(latitude:, longitude:)
    distance_to([latitude, longitude])
  end

  private

  def serialize_schedule
    Date::DAYNAMES.each_with_index do |day, index|
      friendly_schedule[day.downcase].each do |start_time, end_time|
        OpeningTime.create(
          start_time: start_time,
          end_time: end_time,
          weekday: index,
          restaurant: self
        )
      end
    end
  end

  def geocode_meals
    return unless meals.size.positive? && latitude == meals.first.latitude && longitude == meals.first.longitude

    meals.each do |meal|
      meal.update(
        latitude: latitude,
        longitude: longitude
      )
    end
  end

  def to_s
    name
  end
end
