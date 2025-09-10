class CreatePlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :players do |t|
      t.string :first_name
      t.string :last_name
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :avatar
      t.text :description
      t.integer :point, default: 0
      t.integer :point_plus, default: 0
      t.timestamps
    end
  end
end
