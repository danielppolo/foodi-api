require 'httparty'
require 'colorize'
require 'uri'
require 'cgi'

module RappiServices
  class MexicoScrapper
    BASE_URL = 'https://services.mxgrability.rappi.com/api'.freeze
    RESTAURANTS_ENDPOINT = '/restaurant-bus/stores/catalog/home/v2'.freeze
    RESTAURANT_ENDPOINT = '/ms/web-proxy/restaurants-bus/store/id/'.freeze
    TOKEN_ENDPOINT = '/auth/guest_access_token'.freeze
    def initialize
      auth
    end

    def get_restaurants(lat:, lng:)
      return [] unless lat && lng

      auth
      fetch_restaurants(lat: lat, lng: lng)
    end

    def get_restaurant(id)
      fetch_restaurant(id)
    end

    private

    def headers
      {
        "Authorization": "Bearer #{@token}",
        "Content-Type": 'application/json'
      }
    end

    def restaurants_body(lat:, lng:)
      {
        "is_prime": false,
        "lat": lat,
        "lng": lng,
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
      puts "Logged in with #{@token}"
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

    def fetch_restaurants(lat:, lng:)
      response = HTTParty.post(
        URI.escape(BASE_URL + RESTAURANTS_ENDPOINT),
        body: restaurants_body(lat: lat, lng: lng).to_json,
        headers: headers
      )
      data = JSON.parse(response.body, symbolize_names: true)
      data[:stores] || []
    rescue StandardError => e
      puts e
      []
    end

    def fetch_restaurant(id)
      response = HTTParty.post(
        URI.escape("#{BASE_URL}#{RESTAURANT_ENDPOINT}#{id}"),
        body: { store_type: 'restaurant' }.to_json,
        headers: headers
      )
      JSON.parse(response.body, symbolize_names: true)
    rescue StandardError => e
      puts e
      {}
    end
  end
end
