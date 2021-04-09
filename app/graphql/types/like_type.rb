module Types
  class LikeType < BaseObject
    field :id, ID, null: false
    field :meal, Types::MealType, null: false
    field :user, Types::UserType, null: false
  end
end
