class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.text :comments
      t.integer :ratings
      t.references :psychologist, null: false, foreign_key: true

      t.timestamps
    end
  end
end
