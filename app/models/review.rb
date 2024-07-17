class Review < ApplicationRecord
  belongs_to :psychologist

  validates :comments, presence: true
  validates :ratings, presence: true,
                      numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
end
