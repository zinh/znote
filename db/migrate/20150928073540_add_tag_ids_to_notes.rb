class AddTagIdsToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :tag_ids, :integer, array: true, default: []
  end
end
