class AddExternalUrlToRestaurants < ActiveRecord::Migration[6.0]
  def change
    add_column :restaurants, :external_url, :string
  end
end
