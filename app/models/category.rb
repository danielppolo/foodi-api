class Category < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  
  has_many :cuisines
  has_many :restaurants, through: :cuisines
end
