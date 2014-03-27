class UsersController < ApplicationController
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
  end

  def logout
    sign_out
    redirect_to login_path
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
