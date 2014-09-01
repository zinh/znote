# == Schema Information
#
# Table name: notes
#
#  id           :integer          not null, primary key
#  user_id      :integer          not null
#  title        :string(255)
#  content      :text
#  created_at   :datetime
#  updated_at   :datetime
#  content_html :text
#  share_id     :string(255)
#

require 'redcarpet'
require 'securerandom'

class Note < ActiveRecord::Base
  include PgSearch
  before_save :convert_markdown
  scope :user_limit, ->(user_id) { where(user_id: user_id) }
  # scope :free_search, ->(term) { where("title ILIKE :term OR content LIKE :term", term: "%#{term}%")}
  scope :latest, ->(limit) { order(updated_at: :desc).limit(limit)  }
  pg_search_scope :fulltext_search, :against => [[:title, 'A'], [:content, 'B']]

  # convert content column to markdown, save it to content_html
  def convert_markdown
    # self.content_html = Kramdown::Document.new(content).to_html
    self.content_html = markdown(content)
  end# convert_markdown

  # public this note
  def share
    if self.share_id.blank?
      self.share_id = SecureRandom.urlsafe_base64(8)
      self.save!
    end

    self.share_id
  end

  class MarkdownRenderer < Redcarpet::Render::HTML
    def block_code(code, language)
      return "<div class='CodeRay'><div class='code'><pre>#{code}</pre></div></div>" if language.blank?
      CodeRay.highlight(code, language)
    end
  end

  # private
  def markdown(text)
    rndr = MarkdownRenderer.new(:filter_html => true)
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
