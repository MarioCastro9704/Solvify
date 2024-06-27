class AddApproachToPsychologists < ActiveRecord::Migration[7.1]
  def change
    add_column :psychologists, :approach, :string
  end
end
