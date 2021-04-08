module Types
  class RestaurantListType < ListType
    field :results, [RestaurantType], null: false
  end
end
