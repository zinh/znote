class UsersController < ApplicationController
  before_filter :require_login, only: [:edit, :update]

  def create_session
    email = params[:email]
    password = params[:password]
    user = User.authenticate(email, password)
    if user
      sign_in(user)
      redirect_to home_path
    else
      flash[:error] = "Wrong email/password"
      redirect_to login_path
    end
  end

  def create
    user = User.new(user_params)
    if user.save
      sign_in(user)
      redirect_to home_path
    else
      redirect_to register_path
    end
  end

  def edit
    @user = current_user
  end

  def update
    user = current_user
    user.password = update_params[:password] if update_params[:password].present?
    user.email = update_params[:email]
    if user.save!
      redirect_to root_path
    else
      redirect_to edit_path
    end
  end

  def logout
    sign_out
    redirect_to login_path
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def update_params
    params.require(:user).permit(:email, :password)
  end
end
