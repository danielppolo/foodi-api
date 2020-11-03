class CreateCuisines < ActiveRecord::Migration[5.2]
  def change
    create_table :cuisines do |t|
      t.references :restaurant, foreign_key: true
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
