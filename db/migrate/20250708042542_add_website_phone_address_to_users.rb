class AddWebsitePhoneAddressToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :website, :string
    add_column :users, :phone, :string
    add_column :users, :address, :text
  end
end
