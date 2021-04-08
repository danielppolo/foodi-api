module Resolvers
  class MealsResolver < ListResolver
    type Types::MealListType, null: false
    argument :lat, Float, required: false
    argument :lng, Float, required: false

    def resolve(lat:, lng:, **kwargs)
      super(kwargs) do
        if lat && lng
          Meal
            .includes(:restaurant)
            .nearby(latitude: lat, longitude: lng, radius: 2)
        else
          Meal
            .includes(:restaurant)
        end
      end
    end
  end
end
