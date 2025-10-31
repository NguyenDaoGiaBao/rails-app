class Movie < ApplicationRecord
  # Associations
  has_many :showtimes, dependent: :destroy
  has_many :screens, through: :showtimes
  has_many :reviews, dependent: :destroy
  has_many :bookings, through: :showtimes

  # Enums
  enum :status, {
    active: 0,
    inactive: 1,
    coming_soon: 2
  }, default: :active

  GENRES = {
    "Action" => "Hành động",
    "Adventure" => "Phiêu lưu",
    "Animation" => "Hoạt hình",
    "Comedy" => "Hài kịch",
    "Documentary" => "Tài liệu",
    "Drama" => "Chính kịch",
    "Horror" => "Kinh dị",
    "Romance" => "Lãng mạn",
    "Family" => "Gia đình",
    "Sci_Fi" => "Khoa học viễn tưởng"
  }.freeze

  AGE_RATINGS = {
    'P' => 'P - Phù hợp mọi lứa tuổi',
    'K' => 'K - Dành cho trẻ em dưới 13 tuổi',
    'T13' => 'T13 - Từ 13 tuổi trở lên',
    'T16' => 'T16 - Từ 16 tuổi trở lên',
    'T18' => 'T18 - Từ 18 tuổi trở lên',
    'C' => 'C - Cấm chiếu'
  }.freeze

  # Validations
  validates :title, presence: { message: "không được để trống" }, length: { minimum: 10, too_short: "phải có ít nhất %{count} ký tự", maximum: 255, too_long: "tối đa 255 ký tự" }
  validates :duration, presence: true, numericality: {
    greater_than: 0,
    less_than: 500,
    message: "phải từ 1-500 phút"
  }
  validates :age_rating, inclusion: {
    in: %w[P K T13 T16 T18 C],
    message: "phải là P, K, T13, T16, T18 hoặc C"
  }
  validates :genre, presence: true
  validates :description, presence: { message: "không được để trống" }, length: { minimum: 10 , message: "phải có ít nhất %{count} ký tự"}

  has_one_attached :poster_image
  has_many_attached :description_images

  after_save :update_poster_url


  # Scopes
  scope :showing, -> { where(status: :active) }
  scope :coming_soon, -> { where(status: :coming_soon) }
  scope :by_genre, ->(genre) { where(genre: genre) if genre.present? }
  scope :search_by_title, ->(title) { where("LOWER(title) LIKE ?", "%#{title.downcase}%") if title.present? }
  scope :recent, -> { order(created_at: :desc) }

  # Class methods
  def self.genres
    GENRES.keys
  end

  def self.age_ratings_with_labels
    AGE_RATINGS
  end

  # Instance methods
  def duration_in_hours
    return "#{duration} phút" if duration < 60
    hours = duration / 60
    minutes = duration % 60
    minutes > 0 ? "#{hours}h #{minutes}phút" : "#{hours}h"
  end

  def showing_today?
    showtimes.where(show_date: Date.current).active.exists?
  end

  def next_showtime
    showtimes.where('show_date >= ? AND show_time >= ?', Date.current, Time.current)
             .order(:show_date, :show_time)
             .first
  end

  def average_rating
    return 0 if reviews.empty?
    reviews.approved.average(:rating).to_f.round(1)
  end

  def total_reviews
    reviews.approved.count
  end

  def poster_url
    read_attribute(:poster_url).presence || '/assets/no-poster.jpg'
  end

  def status_label
    case status
    when 'active' then 'Đang chiếu'
    when 'inactive' then 'Ngừng chiếu'
    when 'coming_soon' then 'Sắp chiếu'
    end
  end

  def can_be_deleted?
    bookings.confirmed.empty?
  end

  private

  def update_poster_url
    MoviePosterUpdater.new(self).call
  end
end