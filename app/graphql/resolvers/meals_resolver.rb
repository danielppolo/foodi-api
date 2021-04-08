module Resolvers
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
      end
    end
  end
end
