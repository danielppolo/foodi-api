require 'factory_bot_rails'

FactoryBot.define do
  factory :meal_category do
    meal
    category
  end
end
