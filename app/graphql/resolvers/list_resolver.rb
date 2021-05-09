module Resolvers
  class ListResolver < GraphQL::Schema::Resolver
    argument :limit, Int, required: false, default_value: 25
    argument :page, Int, required: false, default_value: 1
    argument :random, Boolean, required: false, default_value: false
    argument :shuffle, Boolean, required: false, default_value: false

    def resolve(page:, limit:, random:, shuffle:)
      count = yield.count(:all)
      pages = (count / limit).ceil
      current = random ? rand(pages) : page
      prev_page = current == 1 || pages < current ? nil : current - 1
      next_page = pages <= current ? nil : current + 1
      results = shuffle ? yield.reorder(:id).page(current).per(limit).shuffle : yield.page(current).per(limit)
      {
        count: count,
        current: current,
        next: next_page,
        prev: prev_page,
        pages: pages,
        results: results
      }
    end
  end
end
