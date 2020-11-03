require_relative "#{Rails.root}/lib/modules/schedule"
require 'date'

class Restaurant < ApplicationRecord
  validates :name, presence: true
  validates :address, presence: true
  validates :schedule, presence: true
  validates :logotype, presence: true
  validates :image, presence: true
  validates :rating, inclusion: { in: 0..5 }
  validates :has_delivery, presence: true

  # enum serving_methods: %i[in_place delivery]
  enum popularity: %i[low medium high]

  has_many :meals, dependent: :destroy
  has_many :cuisines
  has_many :categories, through: :cuisines

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  def self.filter_by_location(lat:, lng:, radius:)
    Restaurant.geocoded.near([lat, lng], radius)
  end

  def self.filter_by_time
    # TODO:
    # Meal.where()
  end

  def coordinates
    [latitude, longitude]
  end

  def open?
    now = Time.new
    today = Schedule.today(schedule)
    open = Schedule.parse_time(today[:open])
    close = Schedule.parse_time(today[:close])
    open_time = Schedule.time(hour: open[:hour], minute: open[:minute])
    close_time = Schedule.time(hour: close[:hour], minute: close[:minute])
    open_time < now && now < close_time
  end
  
  def is_open
    open?
  end

  def eta
    # TODO: Calculate estimated time with Google Maps API
  end

  def distance(latitude:, longitude:)
    distance_to([latitude, longitude])
  end

  def schedule
    Schedule.parse(super)
  end
  
  def self.available(list)
    list.select(&:open?)
  end
end

