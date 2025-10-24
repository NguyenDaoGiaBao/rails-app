class SendPlayerEmailJob < ApplicationJob
  queue_as :default

  def perform(player_ids)
    players = Player.where(id: player_ids)
    players.each do |player|
      Rails.logger.info "📧 Sending email to #{player.email}"
      puts "Email sent to #{player.email}"
    end
  end
end
