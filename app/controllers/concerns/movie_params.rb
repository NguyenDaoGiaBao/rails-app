module MovieParams
  extend ActiveSupport::Concern

  private

  def movie_params
    params.require(:movie).permit(
      :title,
      :description,
      :genre,
      :duration,
      :poster_url,
      :poster_image,
      :age_rating,
      :status
    )
  end

  def movie_filter_params
    params.permit(:search, :genre, :sort, :show_date, :page)
  end
end