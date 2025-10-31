class ScreensController < ApplicationController
  layout "admin"

  # before_action :set_screen, only: [:show, :edit, :update, :destroy]
  def index
    @screens = Screen.all
    authorize Screen
    # render plain: ap(@screens.to_a, plain: true)
  end

  def show
    @screen = set_screen
    respond_to do |format|
      format.html
      format.json { render json: @screen }
    end
  end

  def new
    @screen = Screen.new
    authorize @screen
  end

  def create
    @screen = Screen.new(screen_params)
    if @screen.save
      redirect_to @screen, notice: "Screen was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    set_screen
  end

  # PATCH/PUT /admin/screens/1
  def update
    @screen = set_screen

    if @screen.update(screen_params)
      redirect_to screens_path, notice: "Cập nhật thành công."
    else
      render :show, status: :unprocessable_entity
    end
  end

  # DELETE /admin/screens/1
  def destroy
    @screen = set_screen
    unless @screen.can_be_delete_screen?
      redirect_to screens_path,
                  alert: "Không thể xóa rạp đang hoạt động."
      return
    end
    screen_name = @screen.screen_name
    @screen.destroy
    redirect_to screens_path,
                notice: "Đã xóa rạp '#{screen_name}'."
  end

  def seats
    screen = Screen.find(params[:id])
    render json: { total_seats: screen.total_seats }
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Screen not found" }, status: :not_found
  end

  private

  def set_screen
    @screen = Screen.find(params[:id])
  end

  def screen_params
    params.require(:screen).permit(:screen_name, :total_seats, :screen_type, :status)
  end
end
