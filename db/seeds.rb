puts '🧹 Cleaning meals'
Meal.destroy_all
puts '🧹 Cleaning restaurants'
Restaurant.destroy_all
puts '🧹 Cleaning categories'
Category.destroy_all

scraper = RappiServices::MexicoCityScrapper.new([19.4065495, -99.179647])
scraper.restaurants.first(10).each do |restaurant|
  scraper.parse(restaurant)
end
