class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :psychologist

  validates :date, :time, :end_time, :psychologist_id, :user_id, :reason, presence: true

  after_create :create_videocall

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
      puts "Código de respuesta: #{response.code}"
      puts "Cuerpo de la respuesta: #{response.body}"
    rescue RestClient::ExceptionWithResponse => e
      puts "Error: #{e.response}"
    end
  end
end
