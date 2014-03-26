class NotesController < ApplicationController
  def new
    content = params[:content]
    # TODO: assign user and title
    note = Note.new(user_id: 1, title: 'Test title', content: content)
    if note.save
      render json: {id: note.id}
    else
      render text: "failed", status: 403, layout: false
    end
  end

  def view
    id = params[:id]
    note = Note.find_by(id: params[:id])
    render json: {title: note.title, content: note.content}
  end

  def search
    term = params[:term]
    notes = Note.where("content LIKE ?", "%#{term}%") if term.present?
    if notes
      render json: notes.map{|c| {id: c.id, title: c.title}}
    else
      render text: "no result"
    end
  end
end
