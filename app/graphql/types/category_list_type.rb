module Types
  class CategoryListType < ListType
    field :results, [CategoryType], null: false
  end
end
