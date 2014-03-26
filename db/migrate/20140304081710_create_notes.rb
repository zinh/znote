class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.integer :user_id, null: false
      t.string :title
      t.text :content

      t.timestamps
    end
    add_index :notes, :user_id
  end
end
