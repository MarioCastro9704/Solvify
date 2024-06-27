class CreateServices < ActiveRecord::Migration[7.1]
  def change
    create_table :services do |t|
      t.string :name
      t.string :country
      t.decimal :price_per_session
      t.text :specialties
      t.boolean :published
      t.references :psychologist, null: false, foreign_key: true

      t.timestamps
    end
  end
end
