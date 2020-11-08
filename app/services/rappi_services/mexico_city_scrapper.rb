require 'httparty'

module RappiServices
  class MexicoCityScrapper
    BASE_URL = 'https://services.mxgrability.rappi.com/api'.freeze
    RESTAURANTS_ENDPOINT = '/restaurant-bus/stores/catalog/home/v2'.freeze
    RESTAURANT_ENDPOINT = '/ms/web-proxy/restaurants-bus/store/'.freeze
    TOKEN_ENDPOINT = '/auth/guest_access_token'.freeze

    def initialize(coordinates)
      @lat = coordinates[0]
      @lng = coordinates[1]
      auth
    end

    def restaurants
      response = HTTParty.post(
        BASE_URL + RESTAURANTS_ENDPOINT,
        body: restaurants_body.to_json,
        headers: headers
      )
      JSON.parse response.body, symbolize_names: true
      # data[:stores].map { |store| store[:friendly_url][:friendly_url] }
    end

    def parse(slug)
      response = HTTParty.post(
        BASE_URL + RESTAURANT_ENDPOINT + slug,
        body: restaurants_body.to_json,
        headers: headers
      )
      data = JSON.parse response.body, symbolize_names: true
      parse_restaurant(data)
    end

    # private

    def parse_restaurant(response)
      parse_schedules(response[:schedules])
      # Restaurant.create(
      #   name: response[:name],
      #   # description: ,
      #   image: "https://images.rappi.com.mx/restaurants_background/#{response[:background]}",
      #   address: response[:address],
      #   rating: response[:rating][:score],
      #   has_delivery: response[:delivery_methods].include?("delivery"),
      #   store_type: ,
      #   has_venue: ,
      #   is_active: ,
      #   latitude: response[:location][0],
      #   longitude: response[:location][1],
      #   schedule: parse_schedules(response[:schedules]),
      #   popularity: ,
      # )
    end

    # def parse_meal(response)
    #   Meal.create(
    #     name: ,
    #     description: ,
    #     image: ,
    #     price_cents: ,
    #     popularity: ,
    #     preparation_time: ,
    #     restaurant: ,
    #   )
    # end

    def parse_schedules(schedules)
      if schedules.size == 1
        open_time = schedules[0][:open_time]
        close_time = schedules[0][:close_time]
        schedule = [open_time, close_time]
        return {
          monday: schedule,
          tuesday: schedule,
          wednesday: schedule,
          thursday: schedule,
          friday: schedule,
          saturday: schedule,
          sunday: schedule
        }
      end
      puts schedules.inspect
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
