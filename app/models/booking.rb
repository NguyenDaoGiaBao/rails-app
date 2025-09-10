class Booking < ApplicationRecord
  belongs_to :player
  belongs_to :showtime

  # Enum cho trạng thái đặt vé
  enum :booking_status, {
    pending: 0,
    confirmed: 1,
    cancelled: 2,
    expired: 3
  }

  # Enum cho trạng thái thanh toán
  enum :payment_status, {
    pending_payment: 0,
    completed: 1,
    failed: 2
  }

  # Validation
  validates :booking_code, presence: true, uniqueness: true
  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :seat_count, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :payment_method, presence: true, if: -> { payment_status_completed? }

  # Scope lọc các booking sắp hết hạn
  scope :expiring_soon, ->(minutes = 30) { where(expiry_time: Time.current..(Time.current + minutes.minutes)) }

  # Callback ví dụ: Tự tạo mã booking nếu chưa có
  before_validation :generate_booking_code, on: :create

  private

  def generate_booking_code
    self.booking_code ||= "BK#{SecureRandom.hex(4).upcase}"
  end
end
