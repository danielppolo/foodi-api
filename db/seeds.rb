require 'colorize'
require 'csv'

puts '💣 Cleaning meals'
Meal.destroy_all
puts '💣 Cleaning restaurants'
Restaurant.destroy_all
puts '💣 Cleaning categories'
Category.destroy_all

mexico = RappiServices::MexicoScrapper.new
parser = RappiServices::MexicoParser.new

source = Rails.root.join('db', 'data', 'mexico_city_coordinates.csv')
CSV.foreach(source, col_sep: ',', quote_char: '"', headers: :first_row) do |row|
  puts row['city'].to_s.yellow
  restaurants = mexico.get_restaurants(lat: row['lat'].to_f, lng: row['lng'].to_f)
  restaurants.each do |restaurant|
    parser.parse(mexico.get_restaurant(restaurant[:store_id]))
  end
end
