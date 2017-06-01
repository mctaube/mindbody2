class CreateSessions < ActiveRecord::Migration[5.0]
  def change
    create_table :sessions do |t|
      t.string :session_name
      t.datetime :start_time
      t.datetime :end_time
      t.integer :instructor_id
      t.integer :instructor_mb_id
      t.integer :session_mb_id
      t.string :location

      t.timestamps

    end
  end
end
