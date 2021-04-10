module Resolvers
  class MealsResolver < ListResolver
    type Types::MealListType, null: false
    argument :lat, Float, required: true
    argument :lng, Float, required: true
    argument :category, ID, required: false

    def resolve(lat:, lng:, category: nil, **kwargs)
      super(shuffle: true, **kwargs) do
        if category
          Meal
            .includes(:restaurant)
            .nearby(latitude: lat, longitude: lng, radius: 2)
            .category(category)
            .no_drinks
        else
          Meal
            .includes(:restaurant)
            .nearby(latitude: lat, longitude: lng, radius: 2)
            .no_drinks
        end
      end
    end
  end
end
