namespace :bookings do
  desc "Ensure all bookings have a payment status"
  task ensure_payment_status: :environment do
    Booking.find_each do |booking|
      booking.create_payment_status!(status: 'pending') if booking.payment_status.nil?
    end
  end
end
