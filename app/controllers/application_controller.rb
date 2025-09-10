class ApplicationController < ActionController::Base
  include Authentication
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  helper_method :pundit_user
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def pundit_user
    Current.user
  end

  private
  # Trả về user (admin) hiện tại nếu đã đăng nhập
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def admin_logged_in?
    current_user.present?
  end

  # Trả về front hiện tại nếu đã đăng nhập
  def current_player
    @current_player ||= Player.find_by(id: session[:player_id])
  end

  def player_logged_in?
    current_player.present?
  end

  # Yêu cầu phải là admin (user) đăng nhập
  def require_admin_login
    redirect_to login_path, alert: "You must be logged in as admin." unless admin_logged_in?
  end

  # Yêu cầu phải là front đăng nhập
  def require_player_login
    redirect_to player_login_path, alert: "You must be logged in as front." unless player_logged_in?
  end

  # Xử lý lỗi phân quyền chung
  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_back_or_to(root_path)
  end
end
