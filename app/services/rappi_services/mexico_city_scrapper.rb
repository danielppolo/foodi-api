require 'httparty'

module RappiServices
  class MexicoCityScrapper
    BASE_URL = 'https://services.mxgrability.rappi.com/api'.freeze
    RESTAURANTS_ENDPOINT = '/restaurant-bus/stores/catalog/home/v2'.freeze
    RESTAURANT_ENDPOINT = '/ms/web-proxy/restaurants-bus/store/'.freeze
    TOKEN_ENDPOINT = '/auth/guest_access_token'.freeze

    def initialize(coordinates)
      @lat, @lng = coordinates
      auth
    end

    def restaurants
      response = HTTParty.post(
        BASE_URL + RESTAURANTS_ENDPOINT,
        body: restaurants_body.to_json,
        headers: headers
      )
      data = JSON.parse(response.body, symbolize_names: true)
      data[:stores].map { |store| store[:friendly_url][:friendly_url] }
    end

    def parse(slug)
      response = HTTParty.post(
        BASE_URL + RESTAURANT_ENDPOINT + slug,
        body: restaurants_body.to_json,
        headers: headers
      )
      data = JSON.parse(response.body, symbolize_names: true)
      categories = parse_categories(data[:tags])
      restaurant = parse_restaurant(data)
      create_restaurant_categories(restaurant, categories)
      parse_meals(response, restaurant)
    end

    private

    def parse_restaurant(response)
      Restaurant.create!(
        name: response[:name],
        logotype: "https://images.rappi.com.mx/restaurants_logo/#{response[:logo]}",
        image: "https://images.rappi.com.mx/restaurants_background/#{response[:background]}",
        address: response[:address],
        rating: response[:rating][:score],
        number_of_ratings: response[:rating][:total_reviews],
        has_delivery: response[:delivery_methods].include?('delivery'),
        latitude: response[:location][0],
        longitude: response[:location][1],
        friendly_schedule: parse_schedules(response[:schedules])
      )
    end

    def parse_categories(list)
      list.map do |category|
        Category.find_by(name: category[:name].downcase) || Category.create!(name: category[:name].downcase)
      end
    end

    def create_restaurant_categories(restaurant, categories)
      categories.map do |category|
        RestaurantCategory.create!(
          restaurant: restaurant,
          category: category
        )
      end
    end

    def parse_meals(response, restaurant)
      response['corridors'].each do |group|
        category = Category.find_by(name: group['name'].downcase) || Category.create!(name: group['name'].downcase)
        group['products'].each do |meal|
          meal_instance = Meal.create(
            name: meal['name'],
            description: meal['description'],
            image: "https://images.rappi.com.mx/products/#{meal['image']}",
            price: meal['price'],
            quantity: meal['quantity'],
            preparation_time: response['saturation']['cooking_time'],
            restaurant: restaurant
          )
          MealCategory.create!(meal: meal_instance, category: category) if meal_instance.id
        end
      end
    end

    def parse_schedules(schedules)
      week_schedule = {}
      schedule = []
      schedules.each do |s|
        schedule << [s[:open_time], s[:close_time]]
      end
      Date::DAYNAMES.each do |day|
        week_schedule[day.downcase] = schedule
      end
      week_schedule
    end

    def headers
      {
        "Authorization": "Bearer #{@token}",
        "Content-Type": 'application/json'
      }
    end

    def restaurants_body
      {
        "is_prime": false,
        "lat": @lat,
        "lng": @lng,
        "store_type": 'restaurant'
      }
    end

    def auth
      response =	HTTParty.post(
        BASE_URL + TOKEN_ENDPOINT,
        body: auth_body.to_json
      )
      data = JSON.parse response.body, symbolize_names: true
      @token = data[:access_token]
    end

    def auth_body
      {
        "headers": {
          "normalizedNames": {},
          "lazyUpdate": nil
        },
        "grant_type": 'guest'
      }
    end
  end
end
