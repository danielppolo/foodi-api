require 'factory_bot_rails'

FactoryBot.define do
  factory :portion do
    ingredient
    meal
    grams { 66 }
  end
end
