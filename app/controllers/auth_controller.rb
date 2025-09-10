class AuthController < ApplicationController
  allow_unauthenticated_access only: %i[ login create register ]
  skip_before_action :require_authentication, only: [:store]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to login_path, alert: "Try again later." }

  def login
    if authenticated?
      redirect_to dashboard_index_path
    else
      @login_req = LoginRequest.new
      render :login
    end
  end

  def create
    @login_req = LoginRequest.new(login_params)

    if @login_req.valid?
      user = User.authenticate_by(
        email_address: @login_req.email_address,
        password: @login_req.password
      )

      if user
        if user.active
          start_new_session_for user
          redirect_to dashboard_index_path
        else
          redirect_to login_path, alert: "Your account is not activated. Please contact support."
        end
      else
        flash.now[:alert] = "Incorrect email or password."
        render :login, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "Please correct the errors below."
      render :login, status: :unprocessable_entity
    end
  end

  def logout
    terminate_session
    redirect_to login_path
  end

  def register
    @user = User.new
  end

  def store
    @user = User.new(user_params)
    if @user.save
      redirect_to login_path, notice: "Account created successfully!"
    else
      render :register
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email_address, :password, :user_name)
  end

  def login_params
    params.require(:login_request).permit(:email_address, :password)
  end
end
