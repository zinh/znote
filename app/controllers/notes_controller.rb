class NotesController < ApplicationController
  before_filter :require_login

  def new
    content = params[:content]
    title = params[:title].present? ? params[:title] : "Default title"
    # TODO: assign user and title
    note = Note.new(user_id: current_user.id, title: title, content: content)
    if note.save
      render json: {id: note.id}
    else
      render text: "failed", status: 403, layout: false
    end
  end

  def view
    id = params[:id]
    note = Note.select(:id, :title, :content, :content_html).find_by(id: params[:id])
    render json: {id: note.id, title: note.title, content: note.content, content_html: note.content_html}
  end

  def edit
    note = Note.find_by(id: params[:id], user_id: current_user.id) if params[:id].present?
    if note.present?
      note.update_attributes(note_params)
      render json: {id: note.id}
    else
      render text: "failed", status: 403, layout: false
    end
  end

  def delete
    note = Note.find_by(id: params[:id], user_id: current_user.id) if params[:id].present?
    if note.present?
      note.destroy
      render text: "success", layout: false
    else
      render text: "failed", status: 403, layout: false
    end
  end

  def search
    term = params[:term]
    notes = Note.user_limit(current_user.id).free_search(term) if term.present?
    if notes
      render json: notes.map{|c| {id: c.id, title: c.title}}
    else
      render text: "no result"
    end
  end

  private
  def note_params
    params.permit(:title, :content)
  end
end
