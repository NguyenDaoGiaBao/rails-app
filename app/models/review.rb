class Review < ApplicationRecord
  belongs_to :movie
  belongs_to :player

  # Enum cho trạng thái duyệt review
  enum :status, {
    pending: 0,
    approved: 1,
    rejected: 2
  }

  # Validation
  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :comment, length: { maximum: 1000 }
  validates :movie_id, uniqueness: { scope: :player_id, message: "bạn đã đánh giá phim này rồi" }

  scope :recent, -> { order(created_at: :desc) }
end
