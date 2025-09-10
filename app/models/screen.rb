class Screen < ApplicationRecord
  # Enum cho status
  enum :status, {
    active: 0,
    inactive: 1
  }, default: :active

  # Enum cho loại màn hình (nếu muốn dùng enum thay vì string)
  enum screen_type: {
    '2D': '2D',
    '3D': '3D',
    imax: 'IMAX'
  }, _prefix: true, allow_nil: true

  # Quan hệ (ví dụ: màn hình có thể có nhiều suất chiếu)
  has_many :showtimes, dependent: :destroy

  # Validate dữ liệu
  validates :screen_name, presence: true, uniqueness: true
  validates :total_seats, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
