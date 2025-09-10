class AddColumnsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :name, :string, null: false
    add_column :users, :role, :integer, null: false, default: 3
    add_column :users, :active, :boolean, null: false, default: true
    add_column :users, :avatar, :string
  end
end
