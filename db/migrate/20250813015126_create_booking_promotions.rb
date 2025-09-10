class CreateBookingPromotions < ActiveRecord::Migration[7.0]
  def change
    create_table :booking_promotions do |t|
      t.references :booking, null: false, foreign_key: true
      t.references :promotion, null: false, foreign_key: true
      t.decimal :discount_amount, precision: 10, scale: 2, null: false, comment: "Số tiền được giảm"

      t.timestamps
    end

    add_index :booking_promotions, [:booking_id, :promotion_id], unique: true, name: 'index_booking_promotions_unique'
  end
end