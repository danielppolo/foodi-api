module Types
  class MutationType < BaseObject
    field :like_meal, mutation: Mutations::LikeMeal, authenticate: true
  end
end
