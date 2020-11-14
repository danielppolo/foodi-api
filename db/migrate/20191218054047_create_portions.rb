class CreatePortions < ActiveRecord::Migration[5.2]
  def change
    create_table :portions, id: :uuid do |t|
      t.references :ingredient, foreign_key: true, type: :uuid
      t.references :meal, foreign_key: true, type: :uuid
      t.float :grams

      t.timestamps
    end
  end
end
