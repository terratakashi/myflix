class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(secure_params)

    if @user.save
      flash[:notice] = "The acoount of #{@user.full_name} has been created."
      MyflixMailer.welcome_mail(@user).deliver
      redirect_to sign_in_path
    else
      render "new"
    end
  end

  def show
    @user = User.find(params[:id])
    @queue_items = @user.queue_items
    @reviews = @user.reviews
  end

  private

  def secure_params
    params.require(:user).permit(:email, :full_name, :password)
  end
end
