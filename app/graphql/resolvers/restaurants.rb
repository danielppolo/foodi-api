class Resolvers::Restaurants
  # scope is starting point for search
  scope { Restaurant.all }

  type Types::RestaurantType

  # inline input type definition for the advance filter
  class RestaurantFilter < ::Types::BaseInputObject
    argument :OR, [self], required: false
    argument :description_contains, String, required: false
    argument :url_contains, String, required: false
  end

  # when "filter" is passed "apply_filter" would be called to narrow the scope
  option :filter, type: String, with: :apply_filter

  # apply_filter recursively loops through "OR" branches
  def apply_filter(value)
    "Hello world with #{value}"
  end
end
