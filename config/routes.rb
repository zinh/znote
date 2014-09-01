Znote::Application.routes.draw do
  root to: "statics#home"
  controller :statics do
    get "/home" => :home, as: 'home'
  end
  controller :partials do
    get "partials/note_new" => :note_new
    get "partials/note_view" => :note_view
    get "partials/note_edit" => :note_edit
  end

  controller :notes do
    post "note/new" => :new, as: 'note_new'
    get "note/view/:id" => :view, as: 'note_view'
    post "note/search" => :search, as: 'search'
    post "note/edit" => :edit, as: 'edit'
    get "note/:id/delete" => :delete, as: 'delete'
    get "note/:id/share" => :share, as: 'share'
    get "notes/latest" => :latest, as: 'latest'
    get "share/:share_id" => :view_share, as: 'view_share'
  end

  controller :users do
    get "login" => :login, as: 'login'
    post "login" => :create_session, as: 'create_session'
    get "register" => :register, as: 'register'
    post "register" => :create, as: 'create_user'
    get "logout" => :logout, as: 'logout'
    get "edit" => :edit, as: 'edit_user'
    patch "edit" => :update, as: 'update_user'
  end
end
