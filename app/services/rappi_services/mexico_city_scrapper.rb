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
      data = JSON.parse response.body, symbolize_names: true
      data[:stores].map { |store| store[:friendly_url][:friendly_url]}
    end

    def details(slug)
      response = HTTParty.post(
        BASE_URL + RESTAURANT_ENDPOINT + slug,
        body: restaurants_body.to_json,
        headers: headers
      )
      data = JSON.parse response.body, symbolize_names: true
      puts data
    end

    private

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
        body: auth_body.to_json,
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