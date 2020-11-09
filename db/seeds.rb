Meal.destroy_all
Restaurant.destroy_all
Category.destroy_all

scraper = RappiServices::MexicoCityScrapper.new([19.4065495, -99.179647])
scraper.restaurants.first(20).each do |r|
  scraper.parse(r)
end
