class UsersController < ApplicationController
  layout "admin"
  before_action :set_user, only: %i[ deactive_account delete_my_account update_password password]
  def index
    authorize User, :index?
    @users = User.all

    @breadcrumbs = [
      ["Dashboard", root_path],
      ["List user", nil]
    ]
  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path, notice: "User deleted"
  end

  def deactive_account
  end

  def delete_my_account
    Player.where(created_by_id: @user.id).destroy_all
    @user.destroy
    terminate_session
    redirect_to login_path, notice: "Your account has been deleted."
  end

  def password
    @change_password = ChangePassword.new(user: Current.user)

    @breadcrumbs = [
      ["Dashboard", root_path],
      ["Profile", profile_path(user_name: @user.user_name)],
      ["Change password", nil],
    ]

    render :'users/change_password'
  end

  def update_password
    @change_password = ChangePassword.new(
      current_password: params[:change_password][:current_password],
      password: params[:change_password][:password],
      password_confirmation: params[:change_password][:password_confirmation],
      user: Current.user
    )

    @breadcrumbs = [
      ["Dashboard", root_path],
      ["Profile", profile_path(user_name: Current.user.user_name)],
      ["Change password", nil],
    ]
    if @change_password.save
      redirect_to profile_path(user_name: Current.user.user_name), notice: "Password has been change."
    else
      render :'users/change_password', alert: "An error has occurred."
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
