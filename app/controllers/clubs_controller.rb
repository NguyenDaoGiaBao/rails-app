class ClubsController < ApplicationController
  layout "admin"
  def index
    @clubs = Club.all
  end
end
