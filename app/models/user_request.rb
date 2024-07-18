class UserRequest < ApplicationRecord
  belongs_to :user
  belongs_to :psychologist

  validates :first_payment_status, presence: true
end
