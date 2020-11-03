require_relative "#{Rails.root}/lib/modules/schedule"

module Types 
  class ScheduleType < BaseObject
    field :monday, [String], null: false
    field :tuesday, [String], null: false
    field :wednesday, [String], null: false
    field :thursday, [String], null: false
    field :friday, [String], null: false
    field :saturday, [String], null: false
    field :sunday, [String], null: false
  end
end