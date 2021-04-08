class AddExternalImageUrlToRestaurants < ActiveRecord::Migration[6.0]
  def change
    add_column :restaurants, :external_image_url, :string
  end
end
