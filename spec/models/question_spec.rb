require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'votable'

  describe 'associations' do
    it { should belong_to(:author).class_name('User') }
    it do
      should belong_to(:best_answer).class_name('Answer')
                                    .optional
    end

    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:links).dependent(:destroy) }
    it { should have_one(:reward).dependent(:destroy) }

    it { should accept_nested_attributes_for :links }

    it 'have many attached file' do
      expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
    end
  end

  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end

  describe 'methods' do
    it { should accept_nested_attributes_for :links }
  end
end
