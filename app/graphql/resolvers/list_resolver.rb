module Resolvers
  class ListResolver < GraphQL::Schema::Resolver
    argument :limit, Int, required: false, default_value: 25
    argument :page, Int, required: false, default_value: 1

    def resolve(page:, limit:)
      count = yield.page(page).per(limit).total_count
      prev_page = page == 1 || (count / limit).ceil < page ? nil : page - 1
      next_page = (count / limit).ceil <= page ? nil : page + 1
      {
        count: count,
        next: next_page,
        prev: prev_page,
        results: yield.page(page).per(limit)
      }
    end
  end
end
