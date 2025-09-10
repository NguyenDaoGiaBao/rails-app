class CreateShowtimes < ActiveRecord::Migration[7.0]
  def change
    create_table :showtimes do |t|
      t.references :movie, null: false, foreign_key: true
      t.references :screen, null: false, foreign_key: true
      t.date :show_date, null: false
      t.time :show_time, null: false

      t.decimal :regular_price, precision: 10, scale: 2, null: false, comment: "Giá ghế thường"
      t.decimal :vip_price, precision: 10, scale: 2, null: false, comment: "Giá ghế VIP"
      t.decimal :couple_price, precision: 10, scale: 2, null: false, comment: "Giá ghế đôi"

      t.integer :available_seats, null: false
      t.integer :total_seats, null: false
      t.integer :status, default: 0, comment: "0: active, 1: inactive, 2: sold_out"

      t.timestamps
    end

    add_index :showtimes, [:movie_id, :show_date]
    add_index :showtimes, [:show_date, :show_time]
    add_index :showtimes, :status
    add_index :showtimes, [:show_date, :show_time, :status], name: 'index_showtimes_on_date_time_status'
  end
end