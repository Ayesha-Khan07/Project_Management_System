class UserMailer < ApplicationMailer
  default from: "no-reply@project_hub.com"

  def welcome_email(user)
    @user = user
    mail(           
      to: @user.email,
      subject: "Welcome to the Project Management System!"
    )
  end
end
