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

    Stripe.api_key = ENV['STRIPE_API_KEY']
    token = params[:stripeToken]
    begin
      customer = Stripe::Customer.create(
        :card => token,
        :email => @user.email,
        :description => "Full Name: #{@user.full_name} Email: #{@user.email}")

      charge = Stripe::Charge.create(
        :amount => 999,
        :currency => "usd",
        :customer => customer.id,
        :description => "Sign up charge for: #{@user.email}")
    rescue Stripe::CardError => e
      flash[:error] = e.message
      render "new"
    end

    if @user.save
      handle_invitation
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
