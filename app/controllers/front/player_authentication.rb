module Front
  module PlayerAuthentication
    extend ActiveSupport::Concern

    included do
      helper_method :current_player, :player_logged_in?
      before_action :require_player_login
    end

    def current_player
      @current_player ||= Player.find_by(id: session[:player_id])
    end

    def player_logged_in?
      current_player.present?
    end

    def require_player_login
      redirect_to player_login_path, alert: "Bạn cần đăng nhập để tiếp tục." unless player_logged_in?
    end
  end
end
