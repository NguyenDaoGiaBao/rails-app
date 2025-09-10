module Front
  class ApplicationController < ActionController::Base
    layout "front"

    before_action :require_player_login
    helper_method :current_player, :player_logged_in?

    def current_player
      @current_player ||= Player.find_by(id: session[:player_id])
    end

    def player_logged_in?
      current_player.present?
    end

    def require_player_login
      unless player_logged_in?
        redirect_to player_login_path, alert: "Bạn cần đăng nhập để tiếp tục."
      end
    end
  end
end
