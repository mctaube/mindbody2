class AddMindbodyIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :mindbody_id, :integer
  end
end
