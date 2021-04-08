module Resolvers
  class RestaurantsResolver < ListResolver
    type Types::RestaurantListType, null: false
    argument :lat, Float, required: false
    argument :lng, Float, required: false

    def resolve(lat:, lng:, **kwargs)
      super(kwargs) do
        if lat && lng
          Restaurant
            .nearby(latitude: lat, longitude: lng, radius: 2)
        else
          Restaurant
        end
      end
    end
  end
end
