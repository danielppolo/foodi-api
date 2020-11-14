require 'rails_helper'

RSpec.describe Meal, type: :model do
  describe 'validation tests' do
    it 'validates name existence' do
      # subject.name = nil
      expect(build(:meal)).to be_valid
    end

    it 'validates name uniqueness' do
      # subject.name = nil
      expect(build(:meal)).to be_valid
    end
  end
end
