namespace :jobs do
  desc "Test sending player emails by batch"
  task send_player_emails: :environment do
    Player.in_batches(of: 10) do |players|
      player_ids = players.map(&:id)
      SendPlayerEmailJob.perform_later(player_ids)
    end
    puts "✅ Enqueued SendPlayerEmailJob for all players"
  end
end
