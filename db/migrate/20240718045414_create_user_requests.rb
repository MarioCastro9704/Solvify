class CreateUserRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :user_requests do |t|
      t.references :user, null: false, foreign_key: true
      t.references :psychologist, null: false, foreign_key: true
      t.string :first_payment_status, null: false, default: 'pending'

      t.timestamps
    end
  end
end
