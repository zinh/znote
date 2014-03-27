Znote::Application.routes.draw do
  controller :statics do
    get "statics/home" => :home, as: 'home'
  end
  controller :partials do
    get "partials/note_new" => :note_new
    get "partials/note_view" => :note_view
  end

  controller :notes do
    post "note/new" => :new, as: 'note_new'
    get "note/view/:id" => :view, as: 'note_view'
    post "note/search" => :search, as: 'search'
  end

  controller :users do
    get "login" => :login, as: 'login'
    post "login" => :create_session, as: 'create_session'
    get "register" => :register, as: 'register'
    post "register" => :create, as: 'create_user'
    get "logout" => :logout, as: 'logout'
    get "edit" => :edit, as: 'edit_user'
  end
end
