require 'httparty'
require 'colorize'

module RappiServices
  class Parser
    def parse(data)
      categories = parse_categories(data[:tags])
      restaurant = parse_restaurant(data)
      if restaurant
        create_restaurant_categories(restaurant, categories)
        parse_meals(data, restaurant)
      end
    end

    private

    def parse_restaurant(restaurant)
      puts restaurant[:name]
      restaurant_instance = Restaurant.new(
        name: restaurant[:name],
        external_image_url: restaurant[:background] && "https://images.rappi.com.mx/restaurants_background/#{restaurant[:background]}",
        external_logo_url: restaurant[:logo] && "https://images.rappi.com.mx/restaurants_logo/#{restaurant[:logo]}",
        address: restaurant[:address],
        rating: restaurant[:rating][:score],
        number_of_ratings: restaurant[:rating][:total_reviews],
        has_delivery: restaurant[:delivery_methods].include?('delivery'),
        latitude: restaurant[:location][1],
        longitude: restaurant[:location][0],
        friendly_schedule: parse_schedules(restaurant[:schedules])
      )
      restaurant_instance.save
      restaurant_instance
    end

    def parse_categories(list)
      return unless list

      list.map do |category|
        Category.find_by(name: category[:name].downcase) || Category.create!(name: category[:name].downcase)
      end
    end

    def create_restaurant_categories(restaurant, categories)
      return unless categories

      categories.map do |category|
        RestaurantCategory.create!(
          restaurant: restaurant,
          category: category
        )
      end
    end

    def parse_meals(data, restaurant)
      data[:corridors].each do |group|
        category = Category.find_by(name: group[:name].downcase) || Category.create!(name: group[:name].downcase)
        group[:products].each do |meal|
          print '> '
          puts meal[:name]
          next if !meal[:image] || meal[:image] == 'NO-IMAGE'

          begin
            meal_instance = Meal.new(
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
            meal_instance.save!
            MealCategory.create!(meal: meal_instance, category: category) if meal_instance.id
          rescue StandardError => e
            puts e.to_s.red
          end
        end
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
  end
end
