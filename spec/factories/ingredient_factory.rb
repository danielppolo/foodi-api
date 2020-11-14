require 'factory_bot_rails'

FactoryBot.define do
  factory :ingredient do
    name { 'Ruby' }
    carbs_per_kilo { 66 }
  end
end
