class Service < ApplicationRecord
  belongs_to :psychologist

  validates :name, presence: true
  validates :country, presence: true
  validates :price_per_session, presence: true, numericality: { greater_than: 0 }
  validates :specialties, presence: true

  scope :published, -> { where(published: true) }
end
