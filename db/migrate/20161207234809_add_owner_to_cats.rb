class AddOwnerToCats < ActiveRecord::Migration
  def change
    add_column :cats, :owner_id, :integer
    add_index :cats, :owner_id
  end
end
