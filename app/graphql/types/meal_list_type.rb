module Types
  class MealListType < ListType
    field :results, [MealType], null: false
  end
end
