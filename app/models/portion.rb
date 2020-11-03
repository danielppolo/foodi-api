class Portion < ApplicationRecord
  validates :ingredient, presence: true
  validates :meal, presence: true

  belongs_to :ingredient
  belongs_to :meal
end
