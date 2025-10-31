module Front
  class DashboardController < ApplicationController
    layout "front"
    def index
      @movies = Movie.showing.limit(3)
    end
  end
end
