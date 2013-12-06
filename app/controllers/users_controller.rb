class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
    @user = User.new
  end

  def new_with_invitation_token
    if invitation = Invitation.find_by_token(params[:token])
      @user = User.new(email: invitation.recipient_email)
      @invitation_token = params[:token]
      render "new"
    else
      redirect_to invalid_token_path
    end
  end

  def create
    @user = User.new(secure_params)
    @user_registration = UserRegistration.new(@user).sign_up(params[:stripeToken], params[:invitation_token])
    if @user_registration.successful?
      flash[:notice] = "The acoount of #{@user.full_name} has been created."
      redirect_to sign_in_path
    else
      flash[:error] = @user_registration.error_message
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
