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

    if @user.valid?
      charge = StripeWrapper::Charge.create(email: @user.email, token: params[:stripeToken])
      if charge.successful?
        @user.save
        handle_invitation
        flash[:notice] = "The acoount of #{@user.full_name} has been created."
        MyflixMailer.welcome_mail(@user).deliver
        redirect_to sign_in_path
      else
        flash[:error] = charge.error_message
        render "new"
      end
    else
      flash[:error] = "Invalid user informaiton. Please check the errors below."
      render "new"
    end
  end

  def show
    @user = User.find(params[:id])
    @queue_items = @user.queue_items
    @reviews = @user.reviews
  end

  private

  def handle_invitation
    if invitation = Invitation.find_by_token(params[:invitation_token])
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update_attribute(:token, nil)
    end
  end

  def secure_params
    params.require(:user).permit(:email, :full_name, :password)
  end
end
