class AddAddressToPsychologists < ActiveRecord::Migration[7.1]
  def change
    add_column :psychologists, :address, :string
  end
end
