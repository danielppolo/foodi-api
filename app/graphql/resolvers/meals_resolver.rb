module Resolvers
  class MealsResolver < GraphQL::Schema::Resolver
    type [Types::MealType], null: false
    argument :limit, Int, required: false

    def resolve(limit:)
      if limit
        Meal.all.first(limit)
      else
        Meal.all
      end
    end
  end
end