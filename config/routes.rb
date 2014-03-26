Znote::Application.routes.draw do
  get "statics/home"
  controller :partials do
    get "partials/note_new" => :note_new
    get "partials/note_view" => :note_view
  end

  controller :notes do
    post "note/new" => :new
    get "note/view" => :view
  end
end
