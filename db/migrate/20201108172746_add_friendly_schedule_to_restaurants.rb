class AddFriendlyScheduleToRestaurants < ActiveRecord::Migration[6.0]
  def change
    add_column :restaurants, :friendly_schedule, :json
  end
end
