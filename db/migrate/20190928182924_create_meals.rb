class CreateMeals < ActiveRecord::Migration[5.2]
  def change
    create_table :meals, id: :uuid do |t|
      t.string :name
      t.string :description
      t.boolean :is_kosher, default: false
      t.boolean :is_vegetarian, default: false
      t.boolean :is_vegan, default: false
      t.boolean :is_halal, default: false
      t.integer :price_cents
      t.integer :preparation_time
      t.boolean :is_beverage, default: false
      t.float :popularity, default: 0
      t.references :restaurant, foreign_key: true, type: :uuid
      t.integer :number_of_ratings, default: 0
      t.float :rating, default: 0
      t.integer :quantity, default: 1

      t.timestamps
    end
  end
end
