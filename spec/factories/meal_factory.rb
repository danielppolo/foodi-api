require 'factory_bot_rails'

FactoryBot.define do
  factory :meal do
    name { 'Taco' }
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'assets', 'picture.png'), 'image/png') }
    description { 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.' }
    is_kosher { false }
    is_vegetarian { false }
    is_vegan { false }
    is_halal { false }
    price_cents { 8000 }
    preparation_time { 16 }
    is_beverage { false }
    popularity { 1 }
    restaurant
    number_of_ratings { 8 }
    rating { 32 }
    quantity { 1 }
    latitude { 19.4065495 }
    longitude { -99.179647 }
  end
end
