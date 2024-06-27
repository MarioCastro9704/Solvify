class Psychologist < ApplicationRecord
  belongs_to :user
  has_one :service, dependent: :destroy
  has_many :availabilities
  has_many :reviews
  has_many :bookings
  has_many :users, through: :bookings
  has_many :clientes, class_name: 'User', foreign_key: 'psychologist_id'

  validates :specialty, presence: true
  validates :degree, presence: true
  validates :document_of_identity, presence: true, uniqueness: true
  validates :price_per_hour, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :approach, presence: true
  validates :languages, presence: true
  validates :nationality, presence: true
  serialize :specialties, coder: JSON
  SPECIALTIES = ['Terapia Cognitivo-Conductual', 'Psicoanálisis', 'Terapia Familiar', 'Psicología Infantil', 'Psicología Clínica', 'Neuropsicología', 'Psicología Organizacional', 'Terapia de Pareja'].freeze

  def user_name
    user.name
  end

  def full_name
    "#{user.name} #{user.last_name}"
  end

  def average_rating
    reviews.average(:rating).to_f.round(1)
  end
end
