class CreateBookings < ActiveRecord::Migration[7.1]
  def change
    create_table :bookings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :psychologist, null: false, foreign_key: true
      t.date :date
      t.time :time
      t.string :link_to_meet
      t.string :payment_status

      t.timestamps
    end
  end
end
