class DropChats < ActiveRecord::Migration[7.1]
  def change
    drop_table :chats
  end
end
