class Availability < ApplicationRecord
  belongs_to :psychologist

  validates :business_date, presence: true
  validates :starting_hour, presence: true
  validates :ending_hour, presence: true
  validate :end_time_after_start_time
  # Desactivamos temporalmente la validación que está causando problemas
  # validate :no_overlapping_slots
  
  # Alcances más específicos y eficientes
  scope :free, -> { where(reserved: false) }
  scope :reserved, -> { where(reserved: true) }
  scope :future, -> { where('business_date >= ?', Date.today) }
  scope :past, -> { where('business_date < ?', Date.today) }
  scope :ordered, -> { order(:business_date, :starting_hour) }
  scope :for_day, ->(date) { where(business_date: date) }
  scope :for_psychologist, ->(psychologist_id) { where(psychologist_id: psychologist_id) }
  
  attribute :reserved, :boolean, default: false
  
  def slot_duration_minutes
    ((ending_hour - starting_hour) / 60).to_i
  end
  
  def formatted_time_slot
    "#{starting_hour.strftime('%H:%M')} - #{ending_hour.strftime('%H:%M')}"
  end
  
  private
  
  def end_time_after_start_time
    return unless starting_hour && ending_hour
    
    if ending_hour <= starting_hour
      errors.add(:ending_hour, 'debe ser posterior a la hora de inicio')
    end
  end
  
  # Esta validación será reimplementada más adelante
  # def no_overlapping_slots
  #   return unless psychologist_id && business_date && starting_hour && ending_hour
  #   
  #   sql = "(starting_hour < ? AND ending_hour > ?) OR (starting_hour < ? AND ending_hour > ?) OR (starting_hour >= ? AND ending_hour <= ?)"
  #   
  #   overlaps = Availability.where(psychologist_id: psychologist_id, business_date: business_date)
  #                         .where.not(id: id)
  #                         .where(sql, ending_hour, starting_hour, ending_hour, starting_hour, starting_hour, ending_hour)
  #   
  #   if overlaps.exists?
  #     errors.add(:base, 'El horario se superpone con otra disponibilidad existente')
  #   end
  # end
end
