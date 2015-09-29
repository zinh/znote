module ApplicationHelper
  def current_user
    session[:user]
  end

  def sign_in(user)
    session[:user] = user
  end

  def sign_out
    session[:user] = nil
  end
end
