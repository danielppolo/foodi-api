class AddImageUrlToMeals < ActiveRecord::Migration[6.0]
  def change
    add_column :meals, :external_image_url, :string
  end
end
