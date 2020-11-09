# require_relative "#{Rails.root}/lib/modules/rappi_parser"
# require_relative "#{Rails.root}/lib/modules/schedule"

# directory = "#{Rails.root}/db/data/mx"
# file_list = Dir.children(directory)

Meal.destroy_all
Restaurant.destroy_all
Category.destroy_all

scraper = RappiServices::MexicoCityScrapper.new([19.4065495, -99.179647])
scraper.restaurants.each do |r|
  scraper.parse(r)
end
