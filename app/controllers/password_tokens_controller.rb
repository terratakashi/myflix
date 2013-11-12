class PasswordTokensController < ApplicationController
  def create
    user = User.find_by_email(params[:email])
    if user
      user.update_attribute(:token, SecureRandom.urlsafe_base64)
      MyflixMailer.verify_mail(user).deliver
      render :confirm_password_reset
    else
      flash[:error] = "Invalid user email. Please check again!"
      redirect_to forgot_password_path
    end
  end

  def show
    @token = params[:id]
    redirect_to invalid_token_path unless User.find_by_token(@token)
  end

  def update
    user = User.find_by_token(params[:token])
    if user
      user.update_attributes(password: params[:password], token: nil)
      flash[:notice] = "Your password has been updated successfully! Pleas use new password to sign in!"
      redirect_to sign_in_path
    else
      redirect_to invalid_token_path
    end
  end
end
