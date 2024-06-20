class CreateAvailabilities < ActiveRecord::Migration[7.1]
  def change
    create_table :availabilities do |t|
      t.references :psychologist, null: false, foreign_key: true
      t.date :business_date
      t.time :starting_hour
      t.time :ending_hour

      t.timestamps
    end
  end
end
