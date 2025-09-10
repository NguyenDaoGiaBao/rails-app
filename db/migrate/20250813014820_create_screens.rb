class CreateScreens < ActiveRecord::Migration[7.0]
  def change
    create_table :screens do |t|
      t.string :screen_name, null: false
      t.integer :total_seats, null: false
      t.string :screen_type, comment: "2D, 3D, IMAX"
      t.integer :status, default: 0, comment: "0: active, 1: inactive"

      t.timestamps
    end

    add_index :screens, :status
  end
end
