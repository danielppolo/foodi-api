module Types
  class QueryType < BaseObject
    field :restaurant,
          authenticate: false,
          resolver: Resolvers::RestaurantResolver,
          description: 'Returns a restaurant'

    field :restaurants,
          authenticate: false,
          resolver: Resolvers::RestaurantsResolver,
          description: 'Returns a list of restaurants'

    field :meal,
          authenticate: false,
          resolver: Resolvers::MealResolver,
          description: 'Returns a meal'

    field :meals,
          authenticate: false,
          resolver: Resolvers::MealsResolver,
          description: 'Returns a list of near meals'

    field :categories,
          authenticate: false,
          resolver: Resolvers::CategoriesResolver,
          description: 'Returns a list of near categories'

    #     field :categories
    #           resolver: Resolver::CategoriesResolver,
    #           description: 'Returns the list of nearby categories.'

    #     field :cuisines
    #           resolver: Resolver::CuisinesResolver,
    #           description: 'Returns the list of nearby categories.'
  end
end
