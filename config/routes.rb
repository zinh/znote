Znote::Application.routes.draw do
  get "statics/home"
  controller :partials do
    get "partials/note_new" => :note_new
    get "partials/note_view" => :note_view
  end

  controller :notes do
    post "note/new" => :new, as: 'note_new'
    get "note/view/:id" => :view, as: 'note_view'
    post "note/search" => :search, as: 'search'
  end
end
