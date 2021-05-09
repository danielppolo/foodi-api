module Resolvers
  class MealsResolver < ListResolver
    type Types::MealListType, null: false
    argument :lat, Float, required: false
    argument :lng, Float, required: false
    argument :category, ID, required: false
    argument :restaurant, ID, required: false
    argument :vegan, Boolean, required: false
    argument :vegetarian, Boolean, required: false
    argument :beverage, Boolean, required: false

    def resolve(lat: nil, lng: nil, category: nil, restaurant: nil, vegan: nil, vegetarian: nil, beverage: nil, **kwargs)
      super(**kwargs) do
        Meal
          .includes(:restaurant)
          .nearby(latitude: lat, longitude: lng, radius: 2)
          .restaurant(restaurant)
          .category(category)
          .vegan(vegan)
          .vegetarian(vegetarian)
          .beverages(beverage)
      end
    end
  end
end
