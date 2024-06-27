class AddMissingFieldsToPsychologists < ActiveRecord::Migration[7.1]
  def change
    add_column :psychologists, :languages, :string
    add_column :psychologists, :nationality, :string
    add_column :psychologists, :price_per_session, :decimal
  end
end
