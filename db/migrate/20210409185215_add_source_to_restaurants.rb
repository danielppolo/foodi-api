class AddSourceToRestaurants < ActiveRecord::Migration[6.0]
  def change
    add_column :restaurants, :provider, :string
    add_column :restaurants, :external_id, :string
  end
end
