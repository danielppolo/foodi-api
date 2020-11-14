require 'factory_bot_rails'

FactoryBot.define do
  factory :restaurant_category do
    restaurant
    category
  end
end
