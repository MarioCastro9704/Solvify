class PaymentStatus < ApplicationRecord
  belongs_to :booking

  validates :status, presence: true

  after_save :update_user_request_status, if: :saved_change_to_status?

  private

  def update_user_request_status
    user_request = UserRequest.find_or_create_by(user: booking.user, psychologist: booking.psychologist)
    user_request.update(first_payment_status: status)
  end
end
