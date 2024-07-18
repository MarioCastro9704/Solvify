class UserRequest < ApplicationRecord
  belongs_to :user
  belongs_to :psychologist
  has_many :bookings, through: :user

  validates :first_payment_status, presence: true
end
