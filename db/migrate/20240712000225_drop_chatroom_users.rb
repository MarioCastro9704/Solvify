class DropChatroomUsers < ActiveRecord::Migration[7.1]
  def change
    drop_table :chatrooms_users
  end
end
