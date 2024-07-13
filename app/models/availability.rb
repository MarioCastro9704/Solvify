class Availability < ApplicationRecord
  belongs_to :psychologist

  validates :business_date, presence: true
  validates :starting_hour, presence: true
  validates :ending_hour, presence: true

  scope :free, -> { where(reserved: false) }

  attribute :reserved, :boolean, default: false
end
