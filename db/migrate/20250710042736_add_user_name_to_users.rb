class AddUserNameToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :user_name, :string, null: false
  end
end
