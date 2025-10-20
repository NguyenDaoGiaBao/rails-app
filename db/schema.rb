# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_08_13_015244) do
  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "booking_promotions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "booking_id", null: false
    t.bigint "promotion_id", null: false
    t.decimal "discount_amount", precision: 10, scale: 2, null: false, comment: "Số tiền được giảm"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id", "promotion_id"], name: "index_booking_promotions_unique", unique: true
    t.index ["booking_id"], name: "index_booking_promotions_on_booking_id"
    t.index ["promotion_id"], name: "index_booking_promotions_on_promotion_id"
  end

  create_table "booking_seats", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "booking_id", null: false
    t.bigint "seat_id", null: false
    t.decimal "seat_price", precision: 10, scale: 2, null: false, comment: "Giá của ghế này VND"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id", "seat_id"], name: "index_booking_seats_unique", unique: true
    t.index ["booking_id"], name: "index_booking_seats_on_booking_id"
    t.index ["seat_id"], name: "index_booking_seats_on_seat_id"
  end

  create_table "bookings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "booking_code", null: false
    t.bigint "player_id", null: false
    t.bigint "showtime_id", null: false
    t.decimal "total_amount", precision: 10, scale: 2, null: false, comment: "Tổng tiền VND"
    t.integer "seat_count", null: false
    t.integer "booking_status", default: 0, comment: "0: pending, 1: confirmed, 2: cancelled, 3: expired"
    t.integer "payment_status", default: 0, comment: "0: pending, 1: completed, 2: failed"
    t.string "payment_method", comment: "cash, card, momo, zalopay..."
    t.datetime "expiry_time", comment: "Thời gian hết hạn thanh toán"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "original_amount", precision: 10, scale: 2, comment: "Tiền gốc trước giảm giá"
    t.decimal "discount_amount", precision: 10, scale: 2, default: "0.0", comment: "Tiền được giảm"
    t.string "promotion_code", comment: "Mã giảm giá đã dùng"
    t.index ["booking_code"], name: "index_bookings_on_booking_code", unique: true
    t.index ["booking_status", "expiry_time"], name: "index_bookings_on_status_expiry"
    t.index ["booking_status"], name: "index_bookings_on_booking_status"
    t.index ["expiry_time"], name: "index_bookings_on_expiry_time"
    t.index ["payment_status"], name: "index_bookings_on_payment_status"
    t.index ["player_id"], name: "index_bookings_on_player_id"
    t.index ["showtime_id"], name: "index_bookings_on_showtime_id"
  end

  create_table "clubs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "est"
    t.string "logo"
    t.string "cover"
    t.string "stadium"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "movies", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.string "genre"
    t.integer "duration", comment: "Duration in minutes"
    t.string "poster_url"
    t.string "age_rating", comment: "P, T13, T16, T18"
    t.integer "status", default: 0, comment: "0: active, 1: inactive, 2: coming_soon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_movies_on_status"
    t.index ["title"], name: "index_movies_on_title"
  end

  create_table "players", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "avatar"
    t.text "description"
    t.integer "point", default: 0
    t.integer "point_plus", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "birth_date"
    t.bigint "created_by_id"
    t.index ["created_by_id"], name: "index_players_on_created_by_id"
  end

  create_table "promotions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.text "description"
    t.integer "discount_type", default: 0, comment: "0: percentage, 1: fixed_amount"
    t.decimal "discount_value", precision: 10, scale: 2, null: false
    t.decimal "min_amount", precision: 10, scale: 2, default: "0.0", comment: "Số tiền tối thiểu"
    t.decimal "max_discount", precision: 10, scale: 2, comment: "Giảm tối đa"
    t.integer "usage_limit", default: 0, comment: "Số lần dùng tối đa, 0 = không giới hạn"
    t.integer "used_count", default: 0, comment: "Đã dùng bao nhiêu lần"
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.integer "status", default: 0, comment: "0: active, 1: inactive, 2: expired"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_promotions_on_code", unique: true
    t.index ["start_date", "end_date"], name: "index_promotions_on_start_date_and_end_date"
    t.index ["status"], name: "index_promotions_on_status"
  end

  create_table "reviews", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "movie_id", null: false
    t.bigint "player_id", null: false
    t.integer "rating", null: false, comment: "1-5 stars"
    t.text "comment"
    t.integer "status", default: 0, comment: "0: pending, 1: approved, 2: rejected"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["movie_id", "player_id"], name: "index_reviews_unique", unique: true
    t.index ["movie_id"], name: "index_reviews_on_movie_id"
    t.index ["player_id"], name: "index_reviews_on_player_id"
    t.index ["rating"], name: "index_reviews_on_rating"
    t.index ["status"], name: "index_reviews_on_status"
    t.check_constraint "(`rating` >= 1) and (`rating` <= 5)", name: "reviews_rating_check"
  end

  create_table "screens", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "screen_name", null: false
    t.integer "total_seats", null: false
    t.string "screen_type", comment: "2D, 3D, IMAX"
    t.integer "status", default: 0, comment: "0: active, 1: inactive"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_screens_on_status"
  end

  create_table "seats", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "screen_id", null: false
    t.string "seat_row", null: false, comment: "A, B, C..."
    t.integer "seat_number", null: false, comment: "1, 2, 3..."
    t.integer "seat_type", default: 0, comment: "0: regular, 1: vip, 2: couple"
    t.integer "status", default: 0, comment: "0: active, 1: inactive"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["screen_id", "seat_row", "seat_number"], name: "index_seats_on_screen_row_number", unique: true
    t.index ["screen_id"], name: "index_seats_on_screen_id"
    t.index ["seat_type"], name: "index_seats_on_seat_type"
  end

  create_table "sessions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "showtimes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "movie_id", null: false
    t.bigint "screen_id", null: false
    t.date "show_date", null: false
    t.time "show_time", null: false
    t.decimal "regular_price", precision: 10, scale: 2, null: false, comment: "Giá ghế thường"
    t.decimal "vip_price", precision: 10, scale: 2, null: false, comment: "Giá ghế VIP"
    t.decimal "couple_price", precision: 10, scale: 2, null: false, comment: "Giá ghế đôi"
    t.integer "available_seats", null: false
    t.integer "total_seats", null: false
    t.integer "status", default: 0, comment: "0: active, 1: inactive, 2: sold_out"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["movie_id", "show_date"], name: "index_showtimes_on_movie_id_and_show_date"
    t.index ["movie_id"], name: "index_showtimes_on_movie_id"
    t.index ["screen_id"], name: "index_showtimes_on_screen_id"
    t.index ["show_date", "show_time", "status"], name: "index_showtimes_on_date_time_status"
    t.index ["show_date", "show_time"], name: "index_showtimes_on_show_date_and_show_time"
    t.index ["status"], name: "index_showtimes_on_status"
  end

  create_table "tasks", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.bigint "user_id", null: false
    t.boolean "is_done", default: false
    t.boolean "important", default: false
    t.date "due_date"
    t.integer "priority", default: 1
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.integer "role", default: 3, null: false
    t.boolean "active", default: true, null: false
    t.string "avatar"
    t.string "website"
    t.string "phone"
    t.text "address"
    t.string "user_name", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "booking_promotions", "bookings"
  add_foreign_key "booking_promotions", "promotions"
  add_foreign_key "booking_seats", "bookings"
  add_foreign_key "booking_seats", "seats"
  add_foreign_key "bookings", "players"
  add_foreign_key "bookings", "showtimes"
  add_foreign_key "players", "users", column: "created_by_id"
  add_foreign_key "reviews", "movies"
  add_foreign_key "reviews", "players"
  add_foreign_key "seats", "screens"
  add_foreign_key "sessions", "users"
  add_foreign_key "showtimes", "movies"
  add_foreign_key "showtimes", "screens"
  add_foreign_key "tasks", "users"
end
