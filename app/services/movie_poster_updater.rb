class MoviePosterUpdater
  include Rails.application.routes.url_helpers

  def initialize(movie)
    @movie = movie
  end

  def call
    if @movie.poster_image.attached? && @movie.poster_image.blob.persisted?
      url = rails_blob_path(@movie.poster_image, only_path: true)
      @movie.update_column(:poster_url, url)
    else
      @movie.update_column(:poster_url, nil)
    end
  end
end
