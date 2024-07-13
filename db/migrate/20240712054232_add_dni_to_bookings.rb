class AddDniToBookings < ActiveRecord::Migration[7.1]
  def change
    add_column :bookings, :dni, :string
  end
end
