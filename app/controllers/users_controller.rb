class UsersController < ApplicationController
before_action :already_logged


  def new
    render :new
  end

  def create
    user = User.new(user_params)

    if user.save
      login_user(user)
      redirect_to cats_url
    else
      render :new
    end
  end

  private


  def user_params
    params.require(:user).permit(:username, :password)
  end

end
