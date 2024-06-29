class AddCurrencyToPsychologists < ActiveRecord::Migration[7.1]
  def change
    add_column :psychologists, :currency, :string
  end
end
