require 'factory_bot_rails'

FactoryBot.define do
  factory :user do
    name { 'Daniel' }
    nickname { 'danielppolo' }
    password { '1234567' }
    age { 27 }
    gender { 1 }
    search_radius { 1.2 }
    email { 'foodi@test.com' }
  end
end
