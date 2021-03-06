class Ingredient < ApplicationRecord
  validates :name,
            presence: true,
            uniqueness: true

  has_many :portions, dependent: :destroy
  has_many :meals, through: :portions

  def to_s
    name
  end
end
