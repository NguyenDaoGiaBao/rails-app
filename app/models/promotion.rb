class Promotion < ApplicationRecord
  has_many :booking_promotions, dependent: :restrict_with_error
  has_many :bookings, through: :booking_promotions

  enum :discount_type, { percentage: 0, fixed_amount: 1 }
  enum :status, { active: 0, inactive: 1, expired: 2 }

  validates :code, presence: true, uniqueness: true
  validates :name, :discount_value, :start_date, :end_date, presence: true
  validates :discount_value, numericality: { greater_than: 0 }

  scope :valid_now, -> {
    active.where('start_date <= ? AND end_date >= ?', Date.current, Date.current)
  }
end