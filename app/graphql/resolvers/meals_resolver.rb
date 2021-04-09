module Resolvers
  class MealsResolver < ListResolver
    type Types::MealListType, null: false
    argument :lat, Float, required: true
    argument :lng, Float, required: true

    def resolve(lat:, lng:, **kwargs)
      super(kwargs) do
        Meal
          .includes(:restaurant)
          .nearby(latitude: lat, longitude: lng, radius: 2)
      end
    end
  end
end
