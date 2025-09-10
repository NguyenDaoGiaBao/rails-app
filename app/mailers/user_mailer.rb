class UserMailer < ApplicationMailer
  default from: "from@example.com"
  layout "mailer"

  def reset(user)
    @user = user
    mail(to: @user.email_address,
         subject: "Reset your password",
         template_path: "mails/users",
         template_name: "reset")
  end

  def change_password_email(user)
    @user = user
    mail(to: @user.email_address,
         subject: "Your password has been changed",
         template_path: "mails/users",
         template_name: "change_password")
  end
end
