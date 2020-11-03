class CreatePortions < ActiveRecord::Migration[5.2]
  def change
    create_table :portions do |t|
      t.references :ingredient, foreign_key: true
      t.references :meal, foreign_key: true
      t.float :grams

      t.timestamps
    end
  end
end
