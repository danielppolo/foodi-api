module Types
  class RestaurantType < BaseObject
    field :address, String, null: false
    field :coordinates, [Float], null: false
    field :description, String, null: true
    field :has_delivery, Boolean, null: false
    field :has_venue, Boolean, null: false
    field :id, ID, null: false
    field :external_image_url, String, null: true
    field :is_active, Boolean, null: false
    field :is_open, Boolean, null: false
    field :logotype, String, null: true
    field :meals, [MealType], null: false
    field :name, String, null: false
    field :popularity, Int, null: true
    field :rating, Int, null: true
    field :schedule, ScheduleType, null: false
    field :store_type, String, null: true
    # field :category, Int, null: true
    # field :city, String, null: true
  end
end
