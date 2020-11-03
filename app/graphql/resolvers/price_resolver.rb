module Resolvers
  class PriceResolver < GraphQL::Schema::Resolver
    type String, null: false
    
    def resolve
      object.price.format
    end
  end
end