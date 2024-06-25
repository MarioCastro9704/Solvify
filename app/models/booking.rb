class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :psychologist

  validates :date, presence: true
  validates :time, presence: true
  validates :date, :time, :end_time, :psychologist_id, :user_id, presence: true
end
