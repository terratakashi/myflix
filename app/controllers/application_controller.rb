class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :logged_in?, :current_user

  def require_user
    if !logged_in?
      redirect_to sign_in_path
      flash[:error] = "You need to sign in first!"
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

end
