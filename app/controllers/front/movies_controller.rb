module Front
  class MoviesController  < ApplicationController
    layout "front"
    before_action :set_movie, only: [:show]

    # GET /movies
    def index
      @movies = Movie.showing
                     .includes(:showtimes, :reviews)
                     .search_by_title(params[:search])
                     .by_genre(params[:genre])

      # Filter theo ngày chiếu
      if params[:show_date].present?
        date = Date.parse(params[:show_date]) rescue Date.current
        @movies = @movies.joins(:showtimes)
                         .where(showtimes: { show_date: date, status: :active })
                         .distinct
      end

      # Sắp xếp
      case params[:sort]
      when 'title_asc'
        @movies = @movies.order(:title)
      when 'title_desc'
        @movies = @movies.order(title: :desc)
      when 'rating'
        @movies = @movies.left_joins(:reviews)
                         .group(:id)
                         .order('AVG(reviews.rating) DESC NULLS LAST')
      when 'newest'
        @movies = @movies.order(created_at: :desc)
      else
        @movies = @movies.order(:title)
      end

      @movies = @movies.page(params[:page]).per(12)

      # Data for filters
      @genres = Movie.showing.distinct.pluck(:genre).compact.sort
      @dates = upcoming_show_dates
    end

    # GET /movies/1
    def show
      @showtimes = @movie.showtimes
                         .active
                         .includes(:screen)
                         .where('show_date >= ?', Date.current)
                         .order(:show_date, :show_time)
                         .group_by(&:show_date)

      @reviews = @movie.reviews
                       .approved
                       .includes(:player)
                       .recent
                       .page(params[:page])
                       .per(10)

      @related_movies = Movie.showing
                             .where.not(id: @movie.id)
                             .where(genre: @movie.genre)
                             .limit(6)
                             .order('RAND()') # PostgreSQL, dùng RAND() cho MySQL
    end

    # GET /movies/now_showing
    def now_showing
      @movies = Movie.showing
                     .joins(:showtimes)
                     .where(showtimes: { show_date: Date.current, status: :active })
                     .distinct
                     .includes(:showtimes, :reviews)
                     .page(params[:page])
                     .per(12)

      render :index
    end

    # GET /movies/coming_soon
    def coming_soon
      @movies = Movie.coming_soon
                     .includes(:reviews)
                     .recent
                     .page(params[:page])
                     .per(12)

      render :index
    end

    # GET /movies/search (AJAX)
    def search
      @movies = Movie.showing
                     .search_by_title(params[:q])
                     .limit(10)

      render json: @movies.map { |movie|
        {
          id: movie.id,
          title: movie.title,
          genre: movie.genre,
          duration: movie.duration_in_hours,
          poster_url: movie.poster_url,
          url: movie_path(movie)
        }
      }
    end

    private

    def set_movie
      @movie = Movie.showing.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to movies_path, alert: "Phim không tồn tại hoặc không còn chiếu."
    end

    def upcoming_show_dates
      Showtime.active
              .where('show_date >= ?', Date.current)
              .distinct
              .pluck(:show_date)
              .sort
              .first(7) # 7 ngày tới
    end
  end
end
