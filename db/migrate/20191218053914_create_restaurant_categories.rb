class CreateRestaurantCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :restaurant_categories, id: :uuid do |t|
      t.references :restaurant, foreign_key: true, type: :uuid
      t.references :category, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
