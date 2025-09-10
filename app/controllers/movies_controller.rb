class MoviesController < ApplicationController
  layout "admin"
  before_action :set_movie, only: [:show, :edit, :update, :destroy]

  def index
    @movies = Movie.includes(:showtimes)
                   .search_by_title(params[:search])
                   .by_genre(params[:genre])
                   .order(params[:sort] || 'created_at DESC')
                   .page(params[:page])
                   .per(20)

    @genres = Movie.genres
    @total_movies = @movies.total_count
  end

  # GET /admin/movies/1
  def show
    @showtimes = @movie.showtimes.includes(:screen)
                       .where('show_date >= ?', Date.current)
                       .order(:show_date, :show_time)
    @reviews = @movie.reviews.approved.recent.limit(10)
    byebug
    @stats = movie_stats
  end

  # GET /admin/movies/new
  def new
    @movie = Movie.new
  end

  # GET /admin/movies/1/edit
  def edit
  end

  # POST /admin/movies
  def create
    @movie = Movie.new(movie_params)

    if @movie.save
      redirect_to movie_path(@movie),
                  notice: "Phim '#{@movie.title}' đã được tạo thành công."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /admin/movies/1
  def update
    if @movie.update(movie_params)
      redirect_to movie_path(@movie),
                  notice: "Phim '#{@movie.title}' đã được cập nhật."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /admin/movies/1
  def destroy
    unless @movie.can_be_deleted?
      redirect_to movies_path,
                  alert: "Không thể xóa phim đã có khách đặt vé."
      return
    end

    title = @movie.title
    @movie.destroy
    redirect_to movies_path,
                notice: "Đã xóa phim '#{title}'."
  end

  # POST /admin/movies/1/toggle_status
  def toggle_status
    @movie = Movie.find(params[:id])

    new_status = case @movie.status
                 when 'active' then 'inactive'
                 when 'inactive' then 'active'
                 when 'coming_soon' then 'active'
                 end

    @movie.update!(status: new_status)

    redirect_back(fallback_location: movies_path,
                  notice: "Đã chuyển trạng thái phim thành #{@movie.status_label}")
  end

  # GET /admin/movies/bulk_actions
  def bulk_actions
    movie_ids = params[:movie_ids] || []
    action = params[:bulk_action]

    return redirect_back(fallback_location: movies_path, alert: "Chưa chọn phim nào") if movie_ids.empty?

    movies = Movie.where(id: movie_ids)

    case action
    when 'activate'
      movies.update_all(status: :active)
      message = "Đã kích hoạt #{movies.count} phim"
    when 'deactivate'
      movies.update_all(status: :inactive)
      message = "Đã vô hiệu hóa #{movies.count} phim"
    when 'delete'
      deletable_movies = movies.select(&:can_be_deleted?)
      deletable_movies.each(&:destroy)
      message = "Đã xóa #{deletable_movies.count}/#{movies.count} phim"
    else
      message = "Hành động không hợp lệ"
    end

    redirect_to movies_path, notice: message
  end

  private

  def set_movie
    @movie = Movie.find(params[:id])
  end

  def movie_params
    params.require(:movie).permit(
      :title, :description, :genre, :duration,
      :poster_url, :poster_image, :age_rating, :status
    )
  end

  def movie_stats
    {
      total_showtimes: @movie.showtimes.count,
      upcoming_showtimes: @movie.showtimes.where('show_date >= ?', Date.current).count,
      total_bookings: @movie.bookings.confirmed.count,
      total_revenue: @movie.bookings.confirmed.sum(:total_amount),
      average_rating: @movie.average_rating,
      total_reviews: @movie.total_reviews
    }
  end
end