module Resolvers
  class RestaurantResolver < GraphQL::Schema::Resolver
    type Types::RestaurantType, null: false
    argument :id, ID, required: true

    def resolve(id:)
      Restaurant.find(id)
    end
  end
end
