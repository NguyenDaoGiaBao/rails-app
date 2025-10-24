class PlayersController < ApplicationController
  layout "admin"
  before_action :set_player, only: %i[ show destroy update ]
  before_action :get_clubs, only: %i[ index new show create update ]

  def index
    authorize Player
    @players = policy_scope(Player)
                 .by_keyword(params[:keyword])
                 .order(id: :desc)
                 .page(params[:page]).per(10)

    @breadcrumbs = [
      ["Dashboard", root_path],
      ["List front", nil]
    ]

    Player.find_in_batches(batch_size: 10) do |players|
      player_ids = players.map(&:id)
      SendPlayerEmailJob.perform_later(player_ids)
    end
  end

  def new
    authorize Player
    @player = Player.new

    @breadcrumbs = [
      ["Dashboard", root_path],
      ["Create front", nil]
    ]
  end

  def create
    Rails.logger.debug params.to_json
    @breadcrumbs = [
      ["Dashboard", root_path],
      ["Create front", nil]
    ]
    @player = Player.new(player_params)
    @player.created_by_id = Current.user.id
    if @player.save
      redirect_to players_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @breadcrumbs = [
      ["Dashboard", root_path],
      ["List front", players_path],
      [@player.first_name + ' ' + @player.last_name, nil]
    ]
  end

  def update
    authorize @player
    if @player.update(player_params)
      # render plain: ap(@player, plain: true)
      PlayerMailer.change_password_email(@player).deliver_now
      redirect_to players_path, notice: "Cập nhật thành công."
    else
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
    @player.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to players_path, notice: "Player was deleted." }
    end
  end

  private

  def set_player
    @player = policy_scope(Player).find(params[:id])
  end

  def get_clubs
    @clubs = Club.pluck(:id, :name)
  end

  def player_params
    params.expect(player: [
      :first_name, :last_name, :email, :description, :birth_date, :avatar, :filepond
    ])
  end
end
