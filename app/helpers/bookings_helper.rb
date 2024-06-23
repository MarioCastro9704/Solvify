module BookingsHelper
  def booking_color(booking)
    colors = ['#6f42c1', '#20c997', '#fd7e14', '#dc3545', '#007bff']
    colors[booking.id % colors.length]
  end
end
