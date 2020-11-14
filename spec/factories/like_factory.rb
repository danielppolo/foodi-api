require 'factory_bot_rails'

FactoryBot.define do
  factory :like do
    meal
    user
  end
end
