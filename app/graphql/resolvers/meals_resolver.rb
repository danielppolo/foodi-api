module Resolvers
<<<<<<< Updated upstream
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
=======
  class MealsResolver < GraphQL::Schema::Resolver
    type [Types::MealType], null: false
    argument :limit, Int, required: false
    argument :page, Int, required: false
    argument :lat, Float, required: false
    argument :lng, Float, required: false

    def resolve(limit:, page:, lat:, lng:)
      if limit
        Meal.all.first(limit)
      else
        Meal.nearby(lat, lng, 2)
>>>>>>> Stashed changes
      end
    end
  end
end
