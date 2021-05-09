module Resolvers
  class CategoriesResolver < ListResolver
    type Types::CategoryListType, null: false
    argument :lat, Float, required: true
    argument :lng, Float, required: true

    def resolve(lat:, lng:, **kwargs)
      super(kwargs) do
        Meal.nearby_categories(latitude: lat, longitude: lng, radius: 2)
      end
    end
  end
end
