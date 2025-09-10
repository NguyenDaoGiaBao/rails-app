class SessionsController < ApplicationController
  allow_unauthenticated_access only: [:new, :create, :destroy]
  def new
  end

  def create
    player = Player.find_by(email: params[:email].downcase)

    if player&.authenticate(params[:password])
      session[:player_id] = player.id
      redirect_to front_booking_path, notice: "Player logged in successfully!"
    else
      flash.now[:alert] = "Invalid email or password"
      render :new
    end
  end

  def destroy
    session[:player_id] = nil
    redirect_to player_login_path, notice: "Logged out"
  end
end
