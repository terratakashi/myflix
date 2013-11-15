class MyflixMailer < ActionMailer::Base
  default from: "info@myflix.com"

  def welcome_mail(user)
    @user = user
    attachments.inline["oggy.jpg"] = File.read("app/assets/images/small_cover/oggy.jpg")
    mail to: @user.email, subject: "#{@user.full_name}! Welcome to join Myfilx!"
  end

  def verify_mail(user)
    @user = user
    mail to: @user.email, subject: "Please reset your password by the link!"
  end

  def invitation_mail(invitation)
    @invitation = invitation
    mail to: @invitation.recipient_email, subject: "Please join this really cool site!"
  end
end
