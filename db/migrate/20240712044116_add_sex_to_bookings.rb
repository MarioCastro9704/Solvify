class AddSexToBookings < ActiveRecord::Migration[7.1]
  def change
    add_column :bookings, :sex, :string
  end
end
