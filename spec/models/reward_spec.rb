require 'rails_helper'

RSpec.describe Reward, type: :model do
  describe 'associations' do
    it { should belong_to(:question) }
    it { should belong_to(:user).optional }

    it 'has one attached image' do
      expect(Reward.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
    end
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :image }
  end
end
