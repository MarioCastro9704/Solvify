class DailyService
  def initialize(api_key)
    @api_key = api_key
  end

  def delete_all_rooms
    url = "https://api.daily.co/v1/rooms/"

    begin
      response = RestClient.get(url, { Authorization: "Bearer #{@api_key}" })
      rooms = JSON.parse(response.body)['data']

      rooms.each do |room|
        delete_room(room['name'])
      end
    rescue RestClient::ExceptionWithResponse => e
      puts "Error deleting rooms: #{e.response}"
    end
  end

  private

  def delete_room(room_name)
    url = "https://api.daily.co/v1/rooms/#{room_name}"

    begin
      RestClient.delete(url, { Authorization: "Bearer #{@api_key}" })
      puts "Deleted room: #{room_name}"
    rescue RestClient::ExceptionWithResponse => e
      puts "Error deleting room #{room_name}: #{e.response}"
    end
  end
end
