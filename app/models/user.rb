class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :bookings
  has_one :psychologist
  has_many :psychologists, through: :bookings

  validates :name, presence: true
  validates :last_name, presence: true
  validates :date_of_birth, presence: true
  validates :gender, presence: true
  validates :address, presence: true
  validates :nationality, presence: true
  validates :address, presence: true
  validates :email, uniqueness: true
end
