class Psychologist < ApplicationRecord
  belongs_to :user
  has_one_attached :profile_picture
  has_one :service, dependent: :destroy
  has_many :availabilities, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :clients, through: :bookings, source: :user
  
  # Alcances para consultas comunes
  scope :with_availabilities, -> { includes(:availabilities) }
  scope :with_reviews, -> { includes(:reviews) }
  scope :with_service, -> { includes(:service) }

  validates :specialty, presence: true
  validates :degree, presence: true
  validates :document_of_identity, presence: true, uniqueness: true
  validates :price_per_hour, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :approach, presence: true
  validates :languages, presence: true
  validates :nationality, presence: true
  serialize :specialties, coder: JSON
  accepts_nested_attributes_for :service
  validates :currency, presence: true
  SPECIALTIES = ['Terapia Cognitivo-Conductual', 'Psicoanálisis', 'Terapia Familiar', 'Psicología Infantil', 'Psicología Clínica', 'Neuropsicología', 'Psicología Organizacional', 'Terapia de Pareja'].freeze
  CURRENCIES = [
    ['USD', 'USD'],
    ['EUR', 'EUR'],
    ['GBP', 'GBP'],
    ['JPY', 'JPY'],
    ['COP', 'COP']
  ].freeze

  def user_name
    user.name
  end

  def full_name
    "#{user.name} #{user.last_name}"
  end

  def average_rating
    @average_rating ||= reviews.average(:ratings).to_f.round(1)
  end
  
  def future_availabilities
    availabilities.where('business_date >= ?', Date.today).order(:business_date, :starting_hour)
  end
  
  def available_slots(date = nil)
    scope = availabilities.where(reserved: false)
    scope = scope.where(business_date: date) if date.present?
    scope.order(:business_date, :starting_hour)
  end
end
