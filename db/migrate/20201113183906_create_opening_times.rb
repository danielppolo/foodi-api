class CreateOpeningTimes < ActiveRecord::Migration[6.0]
  def change
    create_table :opening_times do |t|
      t.time :start_time, null: false
      t.time :end_time, null: false
      t.integer :weekday, null: false
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
