module Resolvers
  class ImageResolver < GraphQL::Schema::Resolver
    type String, null: false

    def resolve
      Cloudinary::Utils.cloudinary_url(object.image.key)
    end
  end
end
