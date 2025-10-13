class BookingPromotion < ApplicationRecord
  belongs_to :booking
  belongs_to :promotion

  validates :discount_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :booking_id, uniqueness: { scope: :promotion_id, message: "đã áp dụng khuyến mãi này rồi" }
end