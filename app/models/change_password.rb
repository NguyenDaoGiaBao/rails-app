class ChangePassword
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Callbacks

  attr_accessor :current_password, :password, :password_confirmation, :user

  validates :current_password, presence: { message: "Current password is required" }
  validates :password, presence: { message: "New password is required" }, length: { minimum: 4 }
  validates :password_confirmation, presence: { message: "Password confirmation is required" }
  validate :check_current_password
  validate :new_password_matches_confirmation
  validate :new_password_different_from_current

  define_model_callbacks :save

  after_save :send_mail
  def initialize(attributes = {})
    super
    @user = attributes[:user] if attributes && attributes[:user]
  end

  def save
    return false unless valid?
    # run_callbacks(:save) do
    #   user.password = password
    #   user.save
    # end
    ActiveRecord::Base.transaction do
        user.password = password
        user.save!

        send_mail
    end
    true
    rescue => e
      Rails.logger.error "ChangePassword failed: #{e.message}"
      false
  end

  private

  def check_current_password
    unless user&.authenticate(current_password)
      errors.add(:current_password, 'The password you entered does not match your current password.')
    end
  end

  def new_password_matches_confirmation
    if password != password_confirmation
      errors.add(:password_confirmation, 'Password confirmation does not match.')
    end
  end

  def new_password_different_from_current
    return unless user&.authenticate(password)

    errors.add(:password, 'New password must be different from the current password.')
  end

  def send_mail
    # begin
      UserMailer.change_password_email(user).deliver_now
    # rescue StandardError => e
    #   Rails.logger.error "Failed to send change password email: #{e.message}"
    # end
  end

end