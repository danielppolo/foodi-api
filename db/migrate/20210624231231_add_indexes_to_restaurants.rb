class AddIndexesToRestaurants < ActiveRecord::Migration[6.0]
  def change
    add_index :restaurants, :latitude
    add_index :restaurants, :longitude
  end
end
