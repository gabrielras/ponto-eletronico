class CreatePointPresences < ActiveRecord::Migration[7.0]
  def change
    create_table :point_presences do |t|
      t.references :role, null: false, foreign_key: true
      t.string :schedule_time
      t.datetime :date
      t.json :geocoding
      t.json :authentication

      t.timestamps
    end
  end
end
