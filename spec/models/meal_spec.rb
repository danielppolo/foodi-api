require 'rails_helper'

RSpec.describe Meal, type: :model do
  it 'has a valid factory' do
    expect(build(:meal)).to be_valid
  end

  describe 'validates' do
    let(:meal) { build(:meal) }

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
      expect(meal.rate(1)).to be_equal?(1.0)
      expect(meal.rate(0)).to be_equal?(0.5)
      expect(meal.rate(1)).to be_equal?(0.66)
    end

    it 'accept ratings between 0..1' do
      meal = create(:meal)
      expect(meal.rate(4)).to be(4.0)
    end
  end
end
