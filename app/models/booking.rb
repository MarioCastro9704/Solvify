class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :psychologist
  has_many :messages, dependent: :destroy
  has_one :payment_status, dependent: :destroy

  validates :date, :time, :end_time, :psychologist_id, :user_id, :reason, presence: true
  validate :availability_must_be_free
  validate :user_cannot_book_own_service

  before_validation :set_end_time
  after_create :create_videocall
  after_create :mark_availability_as_reserved
  after_create :ensure_payment_status
  
  # Alcances útiles para consultas frecuentes
  scope :upcoming, -> { where('date > ? OR (date = ? AND time > ?)', Date.today, Date.today, Time.now) }
  scope :past, -> { where('date < ? OR (date = ? AND time < ?)', Date.today, Date.today, Time.now) }
  scope :for_user, ->(user_id) { where(user_id: user_id) }
  scope :for_psychologist, ->(psychologist_id) { where(psychologist_id: psychologist_id) }
  scope :pending_payment, -> { joins(:payment_status).where(payment_statuses: { status: 'pending' }) }
  scope :paid, -> { joins(:payment_status).where(payment_statuses: { status: 'paid' }) }

  def sessions_completed
    self[:sessions_completed] || 0
  end
  
  def remaining_sessions
    (self[:sessions_requested] || 0) - sessions_completed
  end
  
  def payment_complete?
    payment_status&.status == 'paid'
  end

  def create_videocall
    require 'rest-client'

    url = 'https://api.daily.co/v1/rooms/'
    payload = {}
    headers = {
      content_type: :json,
      authorization: "Bearer afd0d96efeb72db1d03e5c1618aaa78a35e2ecac1cd249b411ce2196ceddae26"
    }

    begin
      response = RestClient.post(url, payload.to_json, headers)
      parsed_response = JSON.parse(response)
      
      # Actualización en una sola operación para reducir consultas a la base de datos
      self.update(
        videocall_id: parsed_response['name'],
        link_to_meet: "https://solvify.daily.co/#{parsed_response['name']}"
      )
      
      Rails.logger.info("Video call created: #{parsed_response['name']}")
    rescue RestClient::ExceptionWithResponse => e
      Rails.logger.error("Error creating video call: #{e.response}")
    end
  end

  private

  def ensure_payment_status
    create_payment_status!(status: 'pending') if payment_status.nil?
  end
  
  def set_end_time
    self.end_time = time + 1.hour if time.present?
  end

  def availability_must_be_free
    # Usamos scope para una consulta más limpia y eficiente
    if Availability.for_psychologist(psychologist_id)
                   .for_day(date)
                   .where(starting_hour: time, reserved: true)
                   .exists?
      errors.add(:time, 'Este horario ya está reservado.')
    end
  end

  def mark_availability_as_reserved
    availability = Availability.find_by(psychologist_id: psychologist_id, 
                                       business_date: date, 
                                       starting_hour: time)
    availability&.update(reserved: true)
  end
  
  def user_cannot_book_own_service
    if user_id.present? && psychologist&.user_id == user_id
      errors.add(:base, 'No puedes reservar tu propio servicio')
    end
  end
end
