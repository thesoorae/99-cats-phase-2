class SessionsController < ApplicationController
  before_action :already_logged
  skip_before_action :already_logged, only: [:destroy]


  def destroy
    return if current_user.nil?
    current_user.reset_session_token!
    session[:session_token] = nil

    redirect_to new_session_url
  end

  def new
    render :new
  end

  def create
    user = User.find_by_credentials(
      session_params[:username],
      session_params[:password])

    if user
      user.reset_session_token!
      login_user(user)
      redirect_to cats_url
    else
      ## flash right here?
      render :new
    end
  end


  private

  def session_params
    params.require(:user).permit(:username, :password)
  end
end
