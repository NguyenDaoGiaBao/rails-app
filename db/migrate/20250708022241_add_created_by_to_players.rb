class AddCreatedByToPlayers < ActiveRecord::Migration[8.0]
  def change
    add_reference :players, :created_by, foreign_key: { to_table: :users }
  end
end
