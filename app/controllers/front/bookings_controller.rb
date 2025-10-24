module Front
  class BookingsController < ApplicationController
    layout "front"
    def index
      @movies = ["Oppenheimer", "Inside Out 2", "Avengers: Secret Wars"]
      @timeslots = ["10:00 AM", "2:00 PM", "6:00 PM", "9:00 PM"]
      # render plain: ap(current_player.attributes.to_json, plain: true)
    end

    def new
      @booking = Booking.new
      @showtimes = Showtime.status_active
                           .where("show_date >= ?", Date.current)
                           .includes(:movie, :screen)
                           .order(:show_date, :show_time)
      @player = current_player
    end

    def create
      movie = params[:movie]
      time  = params[:time]
      flash[:notice] = "🎉 Đặt vé '#{movie}' lúc #{time} thành công!"
      redirect_to player_booking_path
    end

    def front_login
      if player_logged_in?
        redirect_to front_booking_path, notice: "Bạn đã đăng nhập rồi!"
      else
        render :front_login
      end
    end
  end
end
