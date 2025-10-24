class PlayerRegistrationForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :first_name, :last_name, :email, :birth_date, :description, :password, :password_confirmation

  validates :first_name, presence: true, length: { minimum: 2 }
  validates :last_name, presence: true, length: { minimum: 2 }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :birth_date, presence: true
  validates :password, presence: true, confirmation: true

  attr_reader :player

  def initialize(player = Player.new, params = {})
    @player = player
    super(params)
  end

  # Rails sẽ hiểu form này như là Player
  def self.model_name
    ActiveModel::Name.new(self, nil, "Player")
  end

  def save(created_by:)
    return false unless valid?

    player.assign_attributes(
      first_name: first_name,
      last_name: last_name,
      email: email,
      birth_date: birth_date,
      description: description,
      password: password,
      created_by_id: created_by.id
    )

    player.save
  end
end
