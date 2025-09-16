class Screen < ApplicationRecord
  enum :status, {
    active: 0,
    inactive: 1
  }, prefix: true, default: :active

  enum :screen_type, {
    '2D': '2D',
    '3D': '3D',
    imax: 'IMAX'
  }, prefix: true, allow_nil: true

  has_many :showtimes, dependent: :destroy

  validates :screen_name, presence: true, uniqueness: true
  validates :total_seats, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
