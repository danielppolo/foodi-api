require 'factory_bot_rails'

FactoryBot.define do
  factory :restaurant do
    name { 'McDo' }
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'assets', 'picture.png'), 'image/png') }
    logotype { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'assets', 'picture.png'), 'image/png') }
    description { 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.' }
    latitude { 19.4065495 }
    longitude { -99.179647 }
    number_of_ratings { 0 }
    rating { 0 }
    popularity { 1 }
    # schedule { 1 }
    friendly_schedule do
      {
        monday: [['09:00:00', '12:00:00']],
        tuesday: [['09:00:00', '12:00:00']],
        wednesday: [['09:00:00', '12:00:00']],
        thursday: [['09:00:00', '12:00:00']],
        friday: [['09:00:00', '12:00:00']],
        saturday: [['09:00:00', '12:00:00']],
        sunday: [['09:00:00', '12:00:00']]
      }
    end
    store_type { 1 }
    address { 'Lissaside 43' }
    has_delivery { true }
    is_active { true }
  end
end
