class NotesController < ApplicationController
  def new
    content = params[:content]
    note = Note.new(user_id: 1, title: 'Test title', content: content)
    if note.save
      render text: "success", layout: false
    else
      render text: "failed", status: 403, layout: false
    end
  end

  def view
    id = params[:id]
    note = Note.find_by(id: params[:id])
    render json: {title: title, content: content}
  end
end
