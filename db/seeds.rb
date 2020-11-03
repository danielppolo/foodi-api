require_relative "#{Rails.root}/lib/modules/rappi_parser"
require_relative "#{Rails.root}/lib/modules/schedule"

directory = "#{Rails.root}/db/data/mx"
file_list = Dir.children(directory)

Restaurant.destroy_all

file_list.first(20).each do |filename|
  puts filename
  file = File.read("#{directory}/#{filename}")
  restaurant_obj = JSON.parse(file)
  opening_times = RappiParser.schedule(restaurant_obj['complete_schedules'])
  restaurant = Restaurant.new(
    name: restaurant_obj['name'],
    schedule: Schedule.to_string(opening_times),
    popularity: restaurant_obj['popularity'],
    logotype: restaurant_obj['logo'],
    store_type: 0,
    image: restaurant_obj['background'],
    address: restaurant_obj['address'],
    description: restaurant_obj['description'],
    rating: restaurant_obj['rating']['score'],
    latitude: restaurant_obj['location'][1],
    longitude: restaurant_obj['location'][0],
    has_delivery: true,
    is_active: true,
    has_venue: true
  )
  meal_list = restaurant_obj['meals']
  meal_list.each do |meal|
    next unless meal.key?('img')

    Meal.create(
      name: meal['name'],
      image: meal['img'].gsub('200', '600'),
      description: meal['description'],
      restaurant: restaurant,
      is_kosher: [true, false].sample,
      is_vegetarian: [true, false].sample,
      is_vegan: [true, false].sample,
      is_halal: [true, false].sample,
      price_cents: meal['price'],
      preparation_time: (5..30).to_a.sample,
      is_beverage: [true, false].sample,
      popularity: rand
    )
  end
  restaurant.save
end
