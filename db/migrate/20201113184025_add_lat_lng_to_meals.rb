class AddLatLngToMeals < ActiveRecord::Migration[6.0]
  def change
    add_column :meals, :lat, :float
    add_column :meals, :lng, :float
  end
end
