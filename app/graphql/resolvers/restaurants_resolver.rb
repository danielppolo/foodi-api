module Resolvers
  class RestaurantsResolver < GraphQL::Schema::Resolver
    type [Types::RestaurantType], null: false
    argument :limit, Int, required: false
    argument :lat, Float, required: false
    argument :lng, Float, required: false
    argument :radius, Float, required: false

    def resolve(limit: nil, lat:, lng:, radius: 2.00)
      restaurants = if lat && lng
                      Restaurant.filter_by_location(lat: lat, lng: lng, radius: radius)
                    else
                      Restaurant.all
                    end
      restaurants = restaurants.first(limit) if limit
      restaurants
    end
  end
end

