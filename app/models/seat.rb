class Seat < ApplicationRecord
  belongs_to :screen

  has_many :booking_seats, dependent: :restrict_with_error
  has_many :bookings, through: :booking_seats

  enum :seat_type, { regular: 0, vip: 1, couple: 2 }
  enum :status, { available: 0, occupied: 1, maintenance: 2 }

  validates :row_number, :column_number, :seat_number, presence: true
  validates :seat_number, uniqueness: { scope: :screen_id }
end
