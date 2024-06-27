class AddSpecialtiesToPsychologists < ActiveRecord::Migration[7.1]
  def change
    add_column :psychologists, :specialties, :text
  end
end
