class AddVisibleToServices < ActiveRecord::Migration[7.1]
  def change
    add_column :services, :visible, :boolean
  end
end
