class Player < ApplicationRecord
  belongs_to :created_by, class_name: 'User'
  has_many :bookings, dependent: :restrict_with_error
  has_many :reviews

  has_secure_password

  has_one_attached :avatar

  validates :first_name,
            presence: { message: "First name is required" },
            length: {
              minimum: 2,
              maximum: 50,
              too_short: "First name must be at least %{count} characters",
              too_long: "First name must be at most %{count} characters"
            }

  validates :last_name,
            presence: { message: "Last name is required" },
            length: {
              minimum: 2,
              maximum: 50,
              too_short: "Last name must be at least %{count} characters",
              too_long: "Last name must be at most %{count} characters"
            }

  validates :birth_date, presence: { message: "Birth date is required" }

  validates :description,
            length: {
              maximum: 200,
              too_long: "Description must be at most %{count} characters"
            }

  validates :email,
            presence: { message: "Email is required" },
            uniqueness: { message: "Email has already been taken" },
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "Email format is invalid"
            }

  validates :point, :point_plus,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 },
            allow_nil: true

  has_one_attached :avatar

  scope :by_keyword, ->(keyword) {
      if keyword.present?
        kw = "%#{keyword.downcase}%"
        where("LOWER(first_name) LIKE :kw OR LOWER(last_name) LIKE :kw", kw: kw)
      end
  }

  def age
    return unless birth_date
    now = Date.current
    age = now.year - birth_date.year
    age -= 1 if now < birth_date + age.years
    age
  end
end
