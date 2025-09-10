class CreateBookings < ActiveRecord::Migration[7.0]
  def change
    create_table :bookings do |t|
      t.string :booking_code, null: false
      t.references :player, null: false, foreign_key: true
      t.references :showtime, null: false, foreign_key: true
      t.decimal :total_amount, precision: 10, scale: 2, null: false, comment: "Tổng tiền VND"
      t.integer :seat_count, null: false
      t.integer :booking_status, default: 0, comment: "0: pending, 1: confirmed, 2: cancelled, 3: expired"
      t.integer :payment_status, default: 0, comment: "0: pending, 1: completed, 2: failed"
      t.string :payment_method, comment: "cash, card, momo, zalopay..."
      t.datetime :expiry_time, comment: "Thời gian hết hạn thanh toán"
      t.text :notes

      t.timestamps
    end

    add_index :bookings, :booking_code, unique: true
    add_index :bookings, :booking_status
    add_index :bookings, :payment_status
    add_index :bookings, :expiry_time
    add_index :bookings, [:booking_status, :expiry_time], name: 'index_bookings_on_status_expiry'
  end
end