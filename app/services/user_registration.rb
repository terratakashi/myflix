class UserRegistration
  attr_reader :error_message
  def initialize(user)
    @user = user
  end

  def sign_up(stripeToken, invitation_token)
    if @user.valid?
      customer = StripeWrapper::Customer.create(email: @user.email, token: stripeToken)
      if customer.successful?
        @user.customer_token = customer.customer_token
        @user.save
        handle_invitation(invitation_token)
        MyflixMailer.welcome_mail(@user).deliver
        @status = :success
      else
        @status = :failed
        @error_message = customer.error_message
      end
    else
        @status = :failed
        @error_message = "Invalid user informaiton. Please check the errors below."
    end
    self
  end

  def successful?
    @status == :success
  end

private

  def handle_invitation(invitation_token)
    if invitation = Invitation.find_by_token(invitation_token)
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update_attribute(:token, nil)
    end
  end
end
