class Psychologist < ApplicationRecord
  belongs_to :user
  has_many :availabilities
  has_many :reviews
  has_many :bookings
end
