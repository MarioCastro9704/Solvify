class CreatePsychologists < ActiveRecord::Migration[7.1]
  def change
    create_table :psychologists do |t|
      t.references :user, null: false, foreign_key: true
      t.string :specialty
      t.string :degree
      t.string :document_of_identity
      t.string :availability
      t.integer :years_of_experience
      t.text :description
      t.decimal :average_rating
      t.decimal :price_per_hour

      t.timestamps
    end
  end
end
