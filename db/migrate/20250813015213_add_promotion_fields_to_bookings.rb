class AddPromotionFieldsToBookings < ActiveRecord::Migration[7.0]
  def change
    add_column :bookings, :original_amount, :decimal, precision: 10, scale: 2, comment: "Tiền gốc trước giảm giá"
    add_column :bookings, :discount_amount, :decimal, precision: 10, scale: 2, default: 0, comment: "Tiền được giảm"
    add_column :bookings, :promotion_code, :string, comment: "Mã giảm giá đã dùng"
  end
end