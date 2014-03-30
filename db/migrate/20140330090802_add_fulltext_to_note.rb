class AddFulltextToNote < ActiveRecord::Migration
  def change
    add_index :notes, :title, type: :fulltext
    add_index :notes, :content, type: :fulltext
    add_index :notes, [:title, :content], type: :fulltext
  end
end
