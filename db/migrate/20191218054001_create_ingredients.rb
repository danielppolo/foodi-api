class CreateIngredients < ActiveRecord::Migration[5.2]
  def change
    create_table :ingredients do |t|
      t.string :name
      t.integer :carbs_per_kilo

      t.timestamps
    end
  end
end
