class LoginRequest
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations

  attribute :email_address, :string
  attribute :password, :string

  validates :email_address, presence: { message: "Email can't be blank." }
  validates :password,
            presence: { message: "Password can't be blank." },
            length: {
              minimum: 4,
              too_short: "Password must be at least %{count} characters",
            }
end