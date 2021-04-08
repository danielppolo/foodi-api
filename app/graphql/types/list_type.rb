module Types
  class ListType < BaseObject
    field :count, Int, null: false
    field :next, Int, null: false
    field :prev, Int, null: false
  end
end
