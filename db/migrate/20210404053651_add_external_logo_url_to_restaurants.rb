class AddExternalLogoUrlToRestaurants < ActiveRecord::Migration[6.0]
  def change
    add_column :restaurants, :external_logo_url, :string
  end
end
