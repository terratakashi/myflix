class SessionsController < ApplicationController

  def new
    redirect_to home_path if logged_in?
  end

  def create
    user = User.find_by_email(params[:email])

    if user && user.authenticate(params[:password])
      if user.active
        session[:user_id] = user.id
        redirect_to home_path, :notice => "You are signed in!"
      else
        flash[:error] = "Your account has been suspened.  Please contact our service!"
        redirect_to root_path
      end
    else
      flash[:error] = "Incorrect email or password. Please try again."
      redirect_to sign_in_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, :notice => "You are signed out!"
  end

end
