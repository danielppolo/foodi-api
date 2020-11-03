class AddColumnsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :gender, :integer
    add_column :users, :age, :integer
    add_column :users, :profile, :integer
    add_column :users, :is_recurrent, :boolean
    add_column :users, :search_radius, :float
  end
end
