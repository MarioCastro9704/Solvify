class AddIndicesForPerformance < ActiveRecord::Migration[7.1]
  def change
    # Índices para disponibilidades
    add_index :availabilities, [:business_date, :starting_hour, :reserved], name: 'index_availabilities_search', if_not_exists: true
    add_index :availabilities, :reserved, if_not_exists: true
    
    # Índices para bookings
    add_index :bookings, [:psychologist_id, :date, :time], name: 'index_bookings_by_psychologist_date_time', if_not_exists: true
    add_index :bookings, :payment_status, if_not_exists: true
    
    # Índice para reviews
    add_index :reviews, [:psychologist_id, :ratings], if_not_exists: true
    
    # Índice para usuarios
    add_index :users, :email, if_not_exists: true
  end
end
