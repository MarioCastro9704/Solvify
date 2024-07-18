class CreatePaymentStatuses < ActiveRecord::Migration[7.1]
  def change
    create_table :payment_statuses do |t|
      t.references :booking, null: false, foreign_key: true
      t.string :status, null: false, default: 'pending'

      t.timestamps
    end
  end
end
