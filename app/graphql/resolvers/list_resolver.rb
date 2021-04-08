module Resolvers
  class ListResolver < GraphQL::Schema::Resolver
    argument :limit, Int, required: false
    argument :page, Int, required: false

    def resolve(**kwargs)
      {
        count: 7,
        next: kwargs[:page] + 1,
        prev: kwargs[:page] - 1,
        results: yield.page(kwargs[:page]).per(kwargs[:limit])
      }
    end
  end
end
