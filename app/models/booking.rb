class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :psychologist
  has_many :messages

  validates :date, :time, :end_time, :psychologist_id, :user_id, :reason, presence: true
  validate :availability_must_be_free

  before_validation :set_end_time
  before_validation :set_default_payment_status

  after_create :create_videocall
  after_create :mark_availability_as_reserved

  def sessions_completed
    self[:sessions_completed]
  end

  def first_payment_status
    self[:payment_status]
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
      self.update(videocall_id: JSON.parse(response)['name'])
      self.update(link_to_meet: "https://solvify.daily.co/#{JSON.parse(response)['name']}")
      puts "Código de respuesta: #{response.code}"
      puts "Cuerpo de la respuesta: #{response.body}"
    rescue RestClient::ExceptionWithResponse => e
      puts "Error: #{e.response}"
    end
  end

  private

  def set_end_time
    self.end_time = time + 1.hour if time.present?
  end

  def set_default_payment_status
    self.payment_status ||= 'pending'
  end

  def availability_must_be_free
    if Availability.where(psychologist: psychologist, business_date: date, starting_hour: time, reserved: true).exists?
      errors.add(:time, 'Este horario ya está reservado.')
    end
  end

  def mark_availability_as_reserved
    availability = Availability.find_by(psychologist: psychologist, business_date: date, starting_hour: time)
    availability.update(reserved: true) if availability
  end
end
