class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :psychologist

  validates :date, presence: true
  validates :time, presence: true
  validates :date, :time, :end_time, :psychologist_id, :user_id, presence: true

  def sessions_completed
    self[:sessions_completed] # Utiliza el atributo real de la base de datos
  end

  def first_payment_status
    self[:payment_status] # Utiliza el atributo real de la base de datos
  end
end
