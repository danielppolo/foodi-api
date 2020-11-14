require 'factory_bot_rails'

FactoryBot.define do
  factory :opening_time do
    weekday { 1 }
    start_time { '17:00:00' }
    end_time { '19:00:00' }
    restaurant
  end
end
