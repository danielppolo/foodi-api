class Portion < ApplicationRecord
  validates :ingredient,
            presence: true,
            uniqueness: {
              scope: :meal,
              message: '%<value> is already an ingredient for this meal.'
            }
  validates :meal, presence: true

  belongs_to :ingredient
  belongs_to :meal

  def to_s
    "#{meal.name} <=> #{ingredient.name}"
  end
end
