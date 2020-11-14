require 'rails_helper'

RSpec.describe Meal, type: :model do
  describe 'validates' do
    it 'name existence' do
      meal = build(:meal)
      meal.name = nil
      expect(meal).to_not be_valid
    end

    it 'name uniqueness' do
      meal1 = build(:meal).save
      meal2 = build(:meal)
      puts meal2
      expect(meal2).to_not be_valid
    end
  end
end
