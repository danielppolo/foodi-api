class CreateRestaurants < ActiveRecord::Migration[5.2]
  def change
    create_table :restaurants do |t|
      t.json :schedule
      t.integer :popularity
      t.integer :store_type
      t.string :name
      t.string :address
      t.string :description
      t.boolean :has_delivery, default: false
      t.integer :number_of_ratings, default: 0
      t.integer :rating, default: 0
      t.float :latitude
      t.float :longitude
      t.boolean :is_active, default: true

      t.timestamps
    end
  end
end
