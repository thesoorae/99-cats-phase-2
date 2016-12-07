class SessionsController < ApplicationController

  def new
    render :new
  end

  def create
    user = User.find_by_credentials(
      session_params[:username],
      session_params[:password])

    if user
      user.reset_session_token!
      session[:session_token] = user.session_token
      redirect_to cats_url
    else
      ## flash right here?
      render :new
    end
  end

  def destroy
    @current_user.reset_session_token! unless @current_user.nil?
    session[:session_token] = nil
  end

  private

  def session_params
    params.require(:user).permit(:username, :password)
  end
end
