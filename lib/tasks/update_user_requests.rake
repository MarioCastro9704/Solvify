namespace :user_requests do
  desc "Update user requests based on bookings"
  task update_status: :environment do
    UserRequest.find_each do |request|
      paid_booking = request.user.bookings.joins(:payment_status).where(payment_statuses: { status: 'paid' }, psychologist: request.psychologist).first
      if paid_booking
        request.update(first_payment_status: 'pagado')
      end
    end
  end
end
