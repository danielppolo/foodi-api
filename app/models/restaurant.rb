require 'date'
require 'json'

class Restaurant < ApplicationRecord
  validates :name, presence: true, uniqueness: { scope: :address }
  validates :address, presence: true
  validates :friendly_schedule, presence: true, schedule: true
  validates :logotype, presence: true
  validates :image, presence: true
  validates :rating, inclusion: { in: 0..5 }
  validates :has_delivery, presence: true

  # enum serving_methods: %i[in_place delivery]
  enum popularity: %i[low medium high]
  enum store_type: %i[restaurant dark_kitchen]

  has_many :meals, dependent: :destroy
  has_many :opening_times, dependent: :destroy
  has_many :restaurant_categories, dependent: :destroy
  has_many :categories, through: :restaurant_categories
  has_one_attached :image
  has_one_attached :logotype

  geocoded_by :address

  after_validation :geocode, if: :will_save_change_to_address?
  after_save :serialize_schedule
  after_save :geocode_meals

  def self.filter_by_location(lat:, lng:, radius:)
    Restaurant.geocoded.near([lat, lng], radius)
  end

  def self.filter_by_time
    # Restaurant.
  end

  def coordinates
    [latitude, longitude]
  end

  def open?
    today = Time.now
    now = today.strftime('%T').gsub(':', '').to_i
    schedule[today.wday].all? do |open, close|
      now.between?(open..close)
    end
    true
  end

  def eta
    distance_to([latitude, longitude]) * 12 # Median pace
  end

  def distance(latitude:, longitude:)
    distance_to([latitude, longitude])
  end

  def self.available(list)
    list.select(&:open?)
  end

  private

  def serialize_schedule
    Date::DAYNAMES.each_with_index do |day, index|
      friendly_schedule[day.downcase].each do |start_time, end_time|
        OpeningTime.create(
          start: start_time,
          end: end_time,
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
end
