class Psychologist < ApplicationRecord
  belongs_to :user
  has_many :availabilities
  has_many :reviews
  has_many :bookings
  has_many :users, through: :bookings
  has_many :clientes, class_name: 'User', foreign_key: 'psychologist_id'

  validates :specialty, presence: true
  validates :degree, presence: true
  validates :document_of_identity, presence: true, uniqueness: true
  validates :price_per_hour, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def user_name
    user.name
  end
end
