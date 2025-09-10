class ProfileController < ApplicationController
  layout "admin"
  before_action :set_user, only: %i[ show update ]
  def show
    @breadcrumbs = [
      ["Dashboard", root_path],
      ["Profile", nil]
    ]
  end

  def update
    @breadcrumbs = [
      ["Dashboard", root_path],
      ["Profile", nil]
    ]

    if @user.update(user_params)
      redirect_to profile_path, notice: "Profile updated"
    else
      flash.now[:alert] = "An error has occurred."
      render :show, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.expect(user: [
      :name, :email_address, :role, :address, :website, :phone, :user_name
    ])
  end

  def set_user
    @user = Current.user
  end
end