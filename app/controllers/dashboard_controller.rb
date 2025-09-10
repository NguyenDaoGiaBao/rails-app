class DashboardController < ApplicationController
  layout "admin"
  def index
    Rails.logger.debug "Session data: #{Current.user}"
    @total_users = User.count
    @total_players = policy_scope(Player).count
    @total_clubs = Club.count

    @breadcrumbs = [
      ["Dashboard", root_path],
    ]
  end
end
