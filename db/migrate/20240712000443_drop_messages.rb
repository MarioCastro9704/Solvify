class DropMessages < ActiveRecord::Migration[7.1]
  def change
    drop_table :messages
  end
end
