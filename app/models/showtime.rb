class Showtime < ApplicationRecord
  belongs_to :movie
  belongs_to :screen

  has_many :bookings, dependent: :destroy

  enum :status, { active: 0, inactive: 1, sold_out: 2 }, prefix: true

  validates :show_date, presence: true
  validates :show_time, presence: true
  validates :regular_price, :vip_price, :couple_price,
            numericality: { greater_than_or_equal_to: 0 }
  validates :available_seats, :total_seats,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
