class AddDayToBookings < ActiveRecord::Migration[7.1]
  def change
    add_column :bookings, :day, :date
  end
end
