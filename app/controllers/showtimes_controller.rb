class ShowtimesController < ApplicationController
  layout "admin"
  before_action :set_showtime, only: [:show, :edit, :update, :destroy]

  # GET /showtimes
  def index
    @showtimes = Showtime.includes(:movie, :screen)
                         .order(show_date: :desc, show_time: :desc)
                         .page(params[:page]).per(20)

    # Filter by status
    if params[:status].present?
      @showtimes = @showtimes.where(status: params[:status])
    end

    # Filter by date
    if params[:date].present?
      @showtimes = @showtimes.where(show_date: params[:date])
    end

    # Filter by movie
    if params[:movie_id].present?
      @showtimes = @showtimes.where(movie_id: params[:movie_id])
    end
  end

  # GET /showtimes/:id
  def show
  end

  # GET /showtimes/new
  def new
    @showtime = Showtime.new
    @movies = Movie.all
    @screens = Screen.all
  end

  # GET /showtimes/:id/edit
  def edit
    @movies = Movie.all
    @screens = Screen.all
  end

  # POST /showtimes
  def create
    @showtime = Showtime.new(showtime_params)

    if @showtime.save
      redirect_to @showtime, notice: 'Suất chiếu đã được tạo thành công.'
    else
      @movies = Movie.all
      @screens = Screen.all
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /showtimes/:id
  def update
    if @showtime.update(showtime_params)
      redirect_to @showtime, notice: 'Suất chiếu đã được cập nhật thành công.'
    else
      @movies = Movie.all
      @screens = Screen.all
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /showtimes/:id
  def destroy
    @showtime.destroy
    redirect_to showtimes_url, notice: 'Suất chiếu đã được xóa thành công.'
  end

  private

  def set_showtime
    @showtime = Showtime.find(params[:id])
  end

  def showtime_params
    params.require(:showtime).permit(
      :movie_id, :screen_id, :show_date, :show_time,
      :regular_price, :vip_price, :couple_price,
      :available_seats, :total_seats, :status
    )
  end
end