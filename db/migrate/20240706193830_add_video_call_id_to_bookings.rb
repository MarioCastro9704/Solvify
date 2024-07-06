class AddVideoCallIdToBookings < ActiveRecord::Migration[7.1]
  def change
    add_column :bookings, :videocall_id, :string, null: true
  end
end
