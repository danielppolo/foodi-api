class OpeningTime < ApplicationRecord
  belongs_to :restaurant

  validates :restaurant, presence: true
  validates :start_time,
            uniqueness: {
              scope: %i[weekday restaurant],
              message: '%<value> already exists for this restaurant'
            },
            presence: true,
            format: {
              with: /\A\d{2}:\d{2}:\d{2}\z/,
              message: 'Time must be in format %H:%M:%S'
            }
  validates :end_time,
            uniqueness: {
              scope: %i[weekday restaurant],
              message: '%<value> already exists for this restaurant'
            },
            presence: true,
            format: {
              with: /\A\d{2}:\d{2}:\d{2}\z/,
              message: 'Time must be in format %H:%M:%S'
            }
  validates :weekday,
            presence: true,
            inclusion: 0..6
end
