class AddContentHtmlToNote < ActiveRecord::Migration
  def change
    add_column :notes, :content_html, :text
  end
end
