class UsersController < ApplicationController
  def index
    redirect_to home_path if logged_in?
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(secure_params)
    @user.password_confirmation = @user.password

    if @user.save
      flash[:notice] = "The acoount of #{@user.full_name} has been created."
      redirect_to sign_in_path
    else
      render "new"
    end
  end

  private

  def secure_params
    params.require(:user).permit(:email, :full_name, :password)
  end
end
