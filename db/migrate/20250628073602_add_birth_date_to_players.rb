class AddBirthDateToPlayers < ActiveRecord::Migration[8.0]
  def change
    add_column :players, :birth_date, :date
  end
end
