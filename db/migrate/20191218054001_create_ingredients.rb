class CreateIngredients < ActiveRecord::Migration[5.2]
  def change
    create_table :ingredients, id: :uuid do |t|
      t.string :name, null: false
      t.integer :carbs_per_kilo

      t.timestamps
    end
  end
end
