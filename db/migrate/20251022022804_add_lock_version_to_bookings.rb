class AddLockVersionToBookings < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :lock_version, :integer
  end
end
