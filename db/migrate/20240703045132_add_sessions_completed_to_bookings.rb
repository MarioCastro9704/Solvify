class AddSessionsCompletedToBookings < ActiveRecord::Migration[7.1]
  def change
    add_column :bookings, :sessions_completed, :integer
  end
end
