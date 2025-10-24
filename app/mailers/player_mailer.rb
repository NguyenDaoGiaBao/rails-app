class PlayerMailer < ApplicationMailer
  default from: "from@example.com"
  layout "mailer"

  def reset(player)
    @player = player
    mail(to: @player.email,
         subject: "Reset your password",
         template_path: "mails/users",
         template_name: "reset")
  end

  def change_password_email(player)
    @player = player
    mail(to: @player.email,
         subject: "Your password has been changed",
         template_path: "mails/players",
         template_name: "change_password")
  end
end
