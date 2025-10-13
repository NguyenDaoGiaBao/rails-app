class BookingSeat < ApplicationRecord
  belongs_to :booking
  belongs_to :seat

  validates :seat_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :booking_id, uniqueness: { scope: :seat_id, message: "đã có ghế này rồi" }
end