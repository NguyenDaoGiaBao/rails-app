class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address,
            presence: { message: "Email can't be blank." },
            uniqueness: { message: 'Email has already been taken.' },
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password,
            presence: { message: "Password can't be blank." },
            length: {
              minimum: 4,
              too_short: "Password must be at least %{count} characters",
            },
            on: :create
  validates :password,
            length: {
              minimum: 4,
              too_short: "Password must be at least %{count} characters",
            },
            allow_blank: true,
            on: :update
  validates :name,
            presence: { message: "Name can't be blank." },
            length: {
              minimum: 2,
              too_short: "Name must be at least %{count} characters",
            }
  enum :role, {
    admin: 1,
    manager: 2,
    member: 3,
  }
end
