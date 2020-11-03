class CreateRestaurants < ActiveRecord::Migration[5.2]
  def change
    create_table :restaurants do |t|
      t.string :schedule
      t.integer :popularity
      t.string :logotype
      t.integer :store_type
      t.string :image
      t.string :name
      t.string :address
      t.string :description
      t.boolean :has_delivery
      t.integer :rating
      t.float :latitude
      t.float :longitude
      t.boolean :is_active
      t.boolean :has_venue

      t.timestamps
    end
  end
end
