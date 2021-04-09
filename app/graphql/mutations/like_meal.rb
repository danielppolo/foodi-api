module Mutations
  class LikeMeal < BaseMutation
    # arguments passed to the `resolve` method
    argument :id, ID, required: true

    # return type from the mutation
    type Types::LikeType

    def resolve(id:)
      Like.create!(user: context[:current_resource], meal_id: id)
    end
  end
end
