class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :psychologist

  validates :date, presence: true
  validates :time, presence: true
  validates :date, :time, :psychologist_id, presence: true
end
