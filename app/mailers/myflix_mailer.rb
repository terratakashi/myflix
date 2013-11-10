class MyflixMailer < ActionMailer::Base
  default from: "info@myflix.com"

  def welcome_mail(user)
    @user = user
    attachments.inline["oggy.jpg"] = File.read("app/assets/images/small_cover/oggy.jpg")
    mail to: @user.email, subject: "#{@user.full_name}! Welcome to join Myfilx!"
  end
end
