class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :psychologist
  validates :sex, inclusion: { in: ['male', 'female'] }, allow_nil: true
  validates :date, presence: true
  validates :time, presence: true
  validates :date, :time, :end_time, :psychologist_id, :user_id, presence: true
  after_create :create_videocall

  def sessions_completed
    self[:sessions_completed] # Utiliza el atributo real de la base de datos
  end

  def first_payment_status
    self[:payment_status] # Utiliza el atributo real de la base de datos
  end

  def create_videocall
    require 'rest-client'

    # URL a la que deseas hacer la solicitud POST
    url = 'https://api.daily.co/v1/rooms/'

    # Datos que deseas enviar en el cuerpo de la solicitud
    payload = {
      # properties: {
      #   exp: Time.now.to_i + 3600
      # }
    }

    # Encabezados opcionales
    headers = {
      content_type: :json,
      authorization: "Bearer afd0d96efeb72db1d03e5c1618aaa78a35e2ecac1cd249b411ce2196ceddae26"
    }

    begin
      # Realiza la solicitud POST
      response = RestClient.post(url, payload.to_json, headers)
      # Manejo de la respuesta
      self.update(videocall_id: JSON.parse(response)['name'])
      puts "Código de respuesta: #{response.code}"
      puts "Cuerpo de la respuesta: #{response.body}"

    rescue RestClient::ExceptionWithResponse => e
      # Manejo de errores
      puts "Error: #{e.response}"
    end
  end
end
