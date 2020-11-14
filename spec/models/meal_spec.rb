require 'rails_helper'

RSpec.describe Meal, type: :model do
  it 'has a valid factory' do
    expect(build(:meal)).to be_valid
  end

  describe 'validates' do
    it '`name` existence' do
      expect(build(:meal, name: nil)).to_not be_valid
    end

    it '`name` uniqueness' do
      restaurant = create(:restaurant, name: 'Casa de Tono')
      create(:meal, restaurant: restaurant)
      expect(build(:meal, restaurant: restaurant)).to_not be_valid
      expect(build(:meal)).to be_valid
    end

    it '`description` existence' do
      expect(build(:meal, description: nil)).to_not be_valid
      expect(build(:meal, description: 'Test length')).to_not be_valid
    end

    it '`price` is positive number' do
      expect(build(:meal, price_cents: 0)).to_not be_valid
      expect(build(:meal, price_cents: 5)).to be_valid
    end
  end

  describe 'should' do
    it 'calculate rating' do
      meal = create(:meal)
      expect(meal.rate(4)).to be(4.0)
      expect(meal.rate(3)).to be(3.5)
    end
  end
end
