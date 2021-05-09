module Resolvers
  class ListResolver < GraphQL::Schema::Resolver
    argument :limit, Int, required: false, default_value: 25
    argument :page, Int, required: false, default_value: 1

    def resolve(page:, limit:, shuffle: false)
      count = yield.page(page).per(limit).total_count
      pages = (count / limit).ceil
      prev_page = page == 1 || pages < page ? nil : page - 1
      next_page = pages <= page ? nil : page + 1
      # FIXME: This isn't random. It just shuffles the page.
      results = shuffle ? yield.page(page).per(limit).shuffle : yield.page(page).per(limit)
      {
        count: count,
        next: next_page,
        prev: prev_page,
        pages: pages,
        results: results
      }
    end
  end
end
