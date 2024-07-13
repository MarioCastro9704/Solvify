class AddReservedToAvailabilities < ActiveRecord::Migration[7.1]
  def change
    add_column :availabilities, :reserved, :boolean
  end
end
