module BookingsHelper
  def booking_color(booking)
    colors = ['#6f42c1', '#20c997', '#fd7e14', '#dc3545', '#007bff']
    colors[booking.id % colors.length]
  end
  def user_color(user)
    colors = ['#FF5733', '#33FF57', '#3357FF', '#F0A500', '#A500F0', '#00F0A5']
    index = user.email[0].ord % colors.length
    colors[index]
  end
end
