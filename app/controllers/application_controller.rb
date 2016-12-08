class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def login_user(user)
    session[:session_token] = user.session_token

  end

  private
  def already_logged
    if current_user
      flash[:errors] = ["You are already logged in"]
      redirect_to cats_url
    end
  end

  def require_login
    unless current_user
      flash[:errors] = ["You must be logged in to access this section"]
      redirect_to cats_url
    end
  end

  def check_owner
    @cat = Cat.find(params[:id])
    unless current_user.id == @cat.owner_id
      flash[:errors] = ["That's not your cat!"]
      redirect_to cat_url(@cat)
    end
  end
end
