class AddShareIdToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :share_id, :string, null: true
    add_index :notes, :share_id
  end
end
