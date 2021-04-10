class AddSourceToMeals < ActiveRecord::Migration[6.0]
  def change
    add_column :meals, :provider, :string
    add_column :meals, :external_id, :string
  end
end
