# == Schema Information
#
# Table name: notes
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  title      :string(255)
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

require 'kramdown'

class Note < ActiveRecord::Base
  before_save :convert_markdown

  # convert content column to markdown, save it to content_html
  def convert_markdown
    self.content_html = Kramdown::Document.new(content).to_html
  end# convert_markdown
end
