class CreateSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :schedules do |t|
      t.references :role, null: false, foreign_key: true

      t.integer :start_time_hour
      t.integer :start_time_minute
      t.integer :initial_interval_hour
      t.integer :initial_interval_minute
      t.integer :final_interval_hour
      t.integer :final_interval_minute
      t.integer :final_time_hour
      t.integer :final_time_minute

      t.boolean :monday, null: false, default: false
      t.boolean :tuesday, null: false, default: false
      t.boolean :wednesday, null: false, default: false
      t.boolean :thursday, null: false, default: false
      t.boolean :friday, null: false, default: false
      t.boolean :saturday, null: false, default: false
      t.boolean :sunday, null: false, default: false

      t.datetime :closing_date
      t.datetime :start_date

      t.timestamps
    end
  end
end
