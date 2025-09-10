module Front
  class BookingsController < ApplicationController
    layout "front"
    def index
      @movies = ["Oppenheimer", "Inside Out 2", "Avengers: Secret Wars"]
      @timeslots = ["10:00 AM", "2:00 PM", "6:00 PM", "9:00 PM"]
      render :index
    end

    def create
      movie = params[:movie]
      time  = params[:time]
      flash[:notice] = "🎉 Đặt vé '#{movie}' lúc #{time} thành công!"
      redirect_to player_booking_path
    end

    def front_login
      if Current.user.present?
        redirect_to dashboard_path, notice: "Bạn đã đăng nhập rồi!"
      else
        render :front_login
      end
    end
  end
end
