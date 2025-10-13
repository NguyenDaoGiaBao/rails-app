class BookingsController < ApplicationController
  layout "admin"
  before_action :set_booking, only: [:show, :edit, :update, :destroy, :confirm, :cancel]

  # GET /bookings
  def index
    @bookings = Booking.includes(:player, showtime: [:movie, :screen])
                       .order(created_at: :desc)

    # Filter by booking status
    if params[:booking_status].present?
      @bookings = @bookings.where(booking_status: params[:booking_status])
    end

    # Filter by payment status
    if params[:payment_status].present?
      @bookings = @bookings.where(payment_status: params[:payment_status])
    end

    # Filter by date range
    if params[:from_date].present? && params[:to_date].present?
      @bookings = @bookings.where(created_at: params[:from_date]..params[:to_date])
    end

    # Filter by booking code
    if params[:booking_code].present?
      @bookings = @bookings.where("booking_code LIKE ?", "%#{params[:booking_code]}%")
    end

    # Filter by player
    if params[:player_id].present?
      @bookings = @bookings.where(player_id: params[:player_id])
    end

    @bookings = @bookings.page(params[:page]).per(20)

    # Statistics
    @stats = {
      total: Booking.count,
      pending: Booking.pending.count,
      confirmed: Booking.confirmed.count,
      cancelled: Booking.cancelled.count,
      expired: Booking.expired.count,
      total_revenue: Booking.confirmed.sum(:total_amount)
    }
  end

  # GET /bookings/:id
  def show
    @booking_seats = @booking.booking_seats.includes(:seat)
    @booking_promotions = @booking.booking_promotions.includes(:promotion)
  end

  # GET /bookings/new
  def new
    @booking = Booking.new
    @showtimes = Showtime.status_active
                         .where("show_date >= ?", Date.current)
                         .includes(:movie, :screen)
                         .order(:show_date, :show_time)
    @players = Player.all
  end

  # GET /bookings/:id/edit
  def edit
    @showtimes = Showtime.includes(:movie, :screen).order(:show_date, :show_time)
    @players = Player.all
  end

  # POST /bookings
  def create
    @booking = Booking.new(booking_params)
    @booking.expiry_time = 15.minutes.from_now if @booking.expiry_time.blank?

    if @booking.save
      redirect_to @booking, notice: 'Đặt vé thành công.'
    else
      @showtimes = Showtime.status_active
                           .where("show_date >= ?", Date.current)
                           .includes(:movie, :screen)
      @players = Player.all
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /bookings/:id
  def update
    if @booking.update(booking_params)
      redirect_to @booking, notice: 'Cập nhật đặt vé thành công.'
    else
      @showtimes = Showtime.includes(:movie, :screen)
      @players = Player.all
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /bookings/:id
  def destroy
    @booking.destroy
    redirect_to bookings_url, notice: 'Đã xóa đặt vé.'
  end

  # POST /bookings/:id/confirm
  def confirm
    if @booking.pending?
      @booking.update(booking_status: :confirmed, payment_status: :completed)
      redirect_to @booking, notice: 'Đã xác nhận đặt vé.'
    else
      redirect_to @booking, alert: 'Không thể xác nhận đặt vé này.'
    end
  end

  # POST /bookings/:id/cancel
  def cancel
    if @booking.pending? || @booking.confirmed?
      # render plain: ap(@booking.attributes.to_json, plain: true)
      @booking.update(booking_status: :cancelled)
      # Return seats to showtime
      @booking.showtime.increment!(:available_seats, @booking.seat_count)
      redirect_to @booking, notice: 'Đã hủy đặt vé.'
    else
      redirect_to @booking, alert: 'Không thể hủy đặt vé này.'
    end
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(
      :player_id, :showtime_id, :total_amount, :seat_count,
      :booking_status, :payment_status, :payment_method,
      :expiry_time, :notes
    )
  end
end