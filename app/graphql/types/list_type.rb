module Types
  class ListType < BaseObject
    field :count, Int, null: false
    field :next, Int, null: true
    field :prev, Int, null: true
    field :pages, Int, null: true
  end
end
