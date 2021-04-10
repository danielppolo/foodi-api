module Types
  class MealType < BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :image, String, null: false
    field :description, String, null: false
    field :is_kosher, Boolean, null: false
    field :is_vegetarian, Boolean, null: false
    field :is_vegan, Boolean, null: false
    field :is_halal, Boolean, null: false
    field :is_beverage, Boolean, null: false
    field :price, resolver: Resolvers::PriceResolver
    field :preparation_time, Int, null: false
    field :popularity, Float, null: false
    field :restaurant, RestaurantType, null: false
    field :distance, Float, null: true
    field :provider, String, null: true
    field :external_id, String, null: true
    field :external_url, String, null: true
    field :external_image_url, String, null: false
  end
end
