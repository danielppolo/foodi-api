class CreateMeals < ActiveRecord::Migration[5.2]
  def change
    create_table :meals do |t|
      t.string :name
      t.string :image
      t.string :description
      t.boolean :is_kosher
      t.boolean :is_vegetarian
      t.boolean :is_vegan
      t.boolean :is_halal
      t.integer :price_cents
      t.integer :preparation_time
      t.boolean :is_beverage
      t.float :popularity
      t.references :restaurant, foreign_key: true

      t.timestamps
    end
  end
end
