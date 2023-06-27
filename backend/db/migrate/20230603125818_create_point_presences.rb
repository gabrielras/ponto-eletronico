class CreatePointPresences < ActiveRecord::Migration[7.0]
  def change
    create_table :point_presences do |t|
      t.references :role, null: false, foreign_key: true
      t.string :state
      t.string :schedule_time
      t.string :latitude
      t.string :longitude
      t.string :local_name

      t.timestamps
    end
  end
end
