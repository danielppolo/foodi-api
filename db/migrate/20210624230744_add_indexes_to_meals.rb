class AddIndexesToMeals < ActiveRecord::Migration[6.0]
  def change
    add_index :meals, :latitude
    add_index :meals, :longitude
  end
end
