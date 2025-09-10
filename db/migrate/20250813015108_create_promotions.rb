class CreatePromotions < ActiveRecord::Migration[7.0]
  def change
    create_table :promotions do |t|
      t.string :code, null: false
      t.string :name, null: false
      t.text :description
      t.integer :discount_type, default: 0, comment: "0: percentage, 1: fixed_amount"
      t.decimal :discount_value, precision: 10, scale: 2, null: false
      t.decimal :min_amount, precision: 10, scale: 2, default: 0, comment: "Số tiền tối thiểu"
      t.decimal :max_discount, precision: 10, scale: 2, comment: "Giảm tối đa"
      t.integer :usage_limit, default: 0, comment: "Số lần dùng tối đa, 0 = không giới hạn"
      t.integer :used_count, default: 0, comment: "Đã dùng bao nhiêu lần"
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.integer :status, default: 0, comment: "0: active, 1: inactive, 2: expired"

      t.timestamps
    end

    add_index :promotions, :code, unique: true
    add_index :promotions, :status
    add_index :promotions, [:start_date, :end_date]
  end
end