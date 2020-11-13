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
  after_validation :serialize_schedule, if: :will_save_change_to_friendly_schedule?

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
    # TODO: Calculate estimated time with Google Maps API
  end

  def distance(latitude:, longitude:)
    distance_to([latitude, longitude])
  end

  def self.available(list)
    list.select(&:open?)
  end

  private

  def serialize_schedule
    self.schedule = Date::DAYNAMES.map do |day|
      friendly_schedule[day.downcase].map do |open, close|
        [open.gsub(':', '').to_i, close.gsub(':', '').to_i]
      end
    end
  end
end
