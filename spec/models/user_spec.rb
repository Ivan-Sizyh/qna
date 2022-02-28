require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it do should have_many(:questions).dependent(:destroy)
                                      .with_foreign_key('author_id')
    end
    it do should have_many(:answers).dependent(:destroy)
                                      .with_foreign_key('author_id')
    end
  end

  describe 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  describe 'methods' do
    context 'is_author? method' do
      let(:question) { create(:question) }
      let(:user) { question.author }

      it 'user author of the question' do
        expect(user).to be_is_author(question)
      end

      it 'user not author of the question' do
        user = create(:user)
        expect(user).to_not be_is_author(question)
      end
    end
  end
end
