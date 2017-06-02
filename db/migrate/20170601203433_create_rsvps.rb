class CreateRsvps < ActiveRecord::Migration[5.0]
  def change
    create_table :rsvps do |t|
      t.integer :session_id
      t.integer :resident_id
      t.boolean :confirmed

      t.timestamps

    end
  end
end
