class CreateOpeningTimes < ActiveRecord::Migration[6.0]
  def change
    create_table :opening_times, id: :uuid do |t|
      t.time :start_time, null: false
      t.time :end_time, null: false
      t.integer :weekday, null: false
      t.references :restaurant, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
