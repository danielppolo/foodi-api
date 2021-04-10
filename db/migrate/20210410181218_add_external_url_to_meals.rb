class AddExternalUrlToMeals < ActiveRecord::Migration[6.0]
  def change
    add_column :meals, :external_url, :string
  end
end
