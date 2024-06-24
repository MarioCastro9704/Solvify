module BookingsHelper
  def booking_color(booking)
    colors = ['#007bff', '#28a745', '#dc3545', '#ffc107', '#17a2b8']
    colors[booking.psychologist_id % colors.length]
  end
  def user_color(user)
    colors = ['#FF5733', '#33FF57', '#3357FF', '#F0A500', '#A500F0', '#00F0A5']
    index = user.email[0].ord % colors.length
    colors[index]
  end
end
