module Types
  class QueryType < BaseObject
    field :restaurant, 
          resolver: Resolvers::RestaurantResolver,
          description: 'Returns a restaurant'

    field :restaurants, 
          resolver: Resolvers::RestaurantsResolver,
          description: 'Returns a list of restaurants'

    field :meal, 
          resolver: Resolvers::MealResolver,
          description: 'Returns a meal'

    field :meals, 
          resolver: Resolvers::MealsResolver,
          description: 'Returns a list of near meals'
    
#     field :categories
#           resolver: Resolver::CategoriesResolver,
#           description: 'Returns the list of nearby categories.'
    
#     field :cuisines
#           resolver: Resolver::CuisinesResolver,
#           description: 'Returns the list of nearby categories.'
  end
end