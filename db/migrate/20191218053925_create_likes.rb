class CreateLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :likes, id: :uuid do |t|
      t.references :meal, foreign_key: true, type: :uuid
      t.references :user, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
