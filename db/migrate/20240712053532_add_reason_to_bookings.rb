class AddReasonToBookings < ActiveRecord::Migration[7.1]
  def change
    add_column :bookings, :reason, :string
  end
end
