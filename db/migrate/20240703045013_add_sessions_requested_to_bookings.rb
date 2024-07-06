class AddSessionsRequestedToBookings < ActiveRecord::Migration[7.1]
  def change
    add_column :bookings, :sessions_requested, :integer
  end
end
