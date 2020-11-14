class CreateMealCategory < ActiveRecord::Migration[6.0]
  def change
    create_table :meal_categories, id: :uuid do |t|
      t.references :meal, null: false, foreign_key: true, type: :uuid
      t.references :category, null: false, foreign_key: true, type: :uuid
    end
  end
end
