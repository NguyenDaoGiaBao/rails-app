class Screen < ApplicationRecord
  enum :status, {
    active: 0,
    inactive: 1,
    maintenance: 2
  }, prefix: true, default: :active

  enum :screen_type, {
    standard: 'Standard',
    '2d': '2D',
    '3d': '3D',
    '4dx': '4DX',
    'imax': 'IMAX',
    'vip': 'VIP',
  }, prefix: true, allow_nil: true

  has_many :showtimes, dependent: :destroy

  validates :screen_name, presence: true, uniqueness: true
  validates :total_seats, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def can_be_delete_screen?
    status != "active"
  end
end
