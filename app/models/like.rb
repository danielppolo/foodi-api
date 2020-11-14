class Like < ApplicationRecord
  belongs_to :meal
  belongs_to :user

  validates :meal, presence: true
  validates :user, presence: true

  def to_s
    "#{meal.name} <=> #{user.name}"
  end
end
