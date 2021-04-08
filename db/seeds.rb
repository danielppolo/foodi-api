puts '🧹 Cleaning meals'
Meal.destroy_all
puts '🧹 Cleaning restaurants'
Restaurant.destroy_all
puts '🧹 Cleaning categories'
Category.destroy_all

dir = '../data/rappi'
Dir.foreach(dir) do |filename|
  next unless filename.include? '.json'

  filepath = dir + '/' + filename
  serialized_data = File.read(filepath)
  data = JSON.parse(serialized_data, symbolize_names: true)
  parser = RappiServices::Parser.new
  parser.parse(data)
end
