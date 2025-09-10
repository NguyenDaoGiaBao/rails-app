class CreateBookingSeats < ActiveRecord::Migration[7.0]
  def change
    create_table :booking_seats do |t|
      t.references :booking, null: false, foreign_key: true
      t.references :seat, null: false, foreign_key: true
      t.decimal :seat_price, precision: 10, scale: 2, null: false, comment: "Giá của ghế này VND"

      t.timestamps
    end

    add_index :booking_seats, [:booking_id, :seat_id], unique: true, name: 'index_booking_seats_unique'
  end
end