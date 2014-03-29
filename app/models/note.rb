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

require 'redcarpet'

class Note < ActiveRecord::Base
  before_save :convert_markdown
  scope :user_limit, ->(user_id) { where(user_id: user_id) }
  scope :free_search, ->(term) { where("title LIKE :term OR content LIKE :term", term: "%#{term}%")}

  # convert content column to markdown, save it to content_html
  def convert_markdown
    # self.content_html = Kramdown::Document.new(content).to_html
    self.content_html = markdown(content)
  end# convert_markdown

  class MarkdownRenderer < Redcarpet::Render::HTML
    def block_code(code, language)
      return "<pre>#{code}</pre>" if language.blank?
      CodeRay.highlight(code, language)
    end
  end

  # private
  def markdown(text)
    rndr = MarkdownRenderer.new(:filter_html => true, :hard_wrap => true)
    options = {
      :fenced_code_blocks => true,
      :no_intra_emphasis => true,
      :autolink => true,
      :strikethrough => true,
      :lax_html_blocks => true,
      :superscript => true
    }
    markdown_to_html = Redcarpet::Markdown.new(rndr, options)
    markdown_to_html.render(text)
  end

end
