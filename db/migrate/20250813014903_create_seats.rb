class CreateSeats < ActiveRecord::Migration[7.0]
  def change
    create_table :seats do |t|
      t.references :screen, null: false, foreign_key: true
      t.string :seat_row, null: false, comment: "A, B, C..."
      t.integer :seat_number, null: false, comment: "1, 2, 3..."
      t.integer :seat_type, default: 0, comment: "0: regular, 1: vip, 2: couple"
      t.integer :status, default: 0, comment: "0: active, 1: inactive"

      t.timestamps
    end

    add_index :seats, [:screen_id, :seat_row, :seat_number], unique: true, name: 'index_seats_on_screen_row_number'
    add_index :seats, :seat_type
  end
end