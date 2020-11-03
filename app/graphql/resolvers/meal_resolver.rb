module Resolvers
  class MealResolver < GraphQL::Schema::Resolver
    type Types::MealType, null: false
    argument :id, Int, required: true
    
    def resolve(id:)
      Meal.find(id)
    end
  end
end