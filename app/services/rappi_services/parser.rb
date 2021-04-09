require 'httparty'
require 'colorize'
require 'active_support/inflections'

CONJUNCIONES = %w[
  y
  e
  ni
  que
  o
  u
  bien
  pero
  para
  mas
  salvo
  sino
  aunque
  ya
  bien
].freeze

BEBIDAS = %w[
  coca
  sprite
  cola
  fanta
  boing
  pepsi
  delaware
  sidral
  mundet
  jamaica
  horchata
  agua
  light
  zero
  milk
].freeze

module RappiServices
  class Parser
    def parse(data)
      categories = parse_categories(data[:tags])
      restaurant = parse_restaurant(data, categories)
      return if restaurant.nil?

      parse_meals(data, restaurant, categories)
    end

    private

    def parse_restaurant(restaurant, categories)
      puts restaurant[:name]
      begin
        restaurant = Restaurant.create!(
          name: restaurant[:name],
          external_image_url: restaurant[:background] && "https://images.rappi.com.mx/restaurants_background/#{restaurant[:background]}",
          external_logo_url: restaurant[:logo] && "https://images.rappi.com.mx/restaurants_logo/#{restaurant[:logo]}",
          address: restaurant[:address],
          rating: restaurant[:rating] && restaurant[:rating][:score],
          number_of_ratings: restaurant[:rating] && restaurant[:rating][:total_reviews],
          has_delivery: restaurant[:delivery_methods]&.include?('delivery') || true,
          latitude: restaurant[:location] && restaurant[:location][1],
          longitude: restaurant[:location] && restaurant[:location][0],
          friendly_schedule: parse_schedules(restaurant[:schedules])
        )
        assign_restaurant_categories(restaurant, categories)
        restaurant
      rescue StandardError => e
        puts e.to_s.red
      end
    end

    def parse_categories(list)
      return unless list

      list.map do |category|
        name = remove_accents(category[:name].downcase.strip)
        name = singularize(name)
        Category.find_or_create_by(name: name)
      end
    end

    def parse_meals(data, restaurant, categories)
      data[:corridors].each do |group|
        group[:products].each do |meal|
          next if !meal[:image] || meal[:image] == 'NO-IMAGE'

          begin
            puts "> #{meal[:name]}"
            meal_instance = Meal.create!(
              name: meal[:name],
              external_image_url: "https://images.rappi.com.mx/products/#{meal[:image]}",
              description: meal[:description],
              price: meal[:price],
              quantity: meal[:quantity],
              preparation_time: data[:saturation][:cooking_time],
              restaurant: restaurant,
              latitude: restaurant.latitude,
              longitude: restaurant.longitude
            )
            generate_categories(meal_instance)
            assign_meal_categories(meal_instance, categories)
          rescue StandardError => e
            puts e.to_s.red
          end
        end
      end
    end

    # Name initially
    def generate_categories(meal)
      words = meal.name.strip.downcase.split(' ')
      words_alpha = words.map do |word|
        name = remove_accents(word.gsub(/\W/, '').gsub(/\d/, ''))
        singularize(name)
      end
      whitelisted_words = words_alpha.select do |word|
        word && word.length > 3 && !CONJUNCIONES.include?(word) && BEBIDAS.none? { |bebida| word.include? bebida }
      end
      whitelisted_words.each do |word|
        category = Category.find_or_create_by(name: word)
        puts "  `#{category.name}`".yellow
        MealCategory.create!(meal: meal, category: category)
      rescue StandardError => e
        puts e.to_s.red
      end
    end

    def assign_restaurant_categories(restaurant, categories)
      return unless categories

      categories.each do |category|
        puts "  `#{category.name}`".yellow
        RestaurantCategory.create!(
          restaurant: restaurant,
          category: category
        )
      end
    end

    def assign_meal_categories(meal, categories)
      return unless categories

      categories.each do |category|
        puts "  `#{category.name}`".yellow
        MealCategory.create!(
          meal: meal,
          category: category
        )
      end
    end

    def parse_schedules(schedules)
      week_schedule = {}
      day_schedule = []
      schedules.each do |schedule|
        day_schedule << [schedule[:open_time], schedule[:close_time]]
      end
      Date::DAYNAMES.each do |day|
        week_schedule[day.downcase] = day_schedule
      end
      week_schedule
    end

    def remove_accents(word)
      return unless word

      word.gsub(/á/, 'a').gsub(/é/, 'e').gsub(/í/, 'i').gsub(/ó/, 'o').gsub(/ú/, 'u')
    end

    def singularize(word)
      return word[0..-3] if word[-2..] == 'es'
      return word[0..-2] if word[-1] == 's'

      word
    end
  end
end
