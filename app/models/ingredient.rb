class Ingredient < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :portions
  has_many :meals, through: :portions
end
