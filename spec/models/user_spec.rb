require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it do should have_many(:questions).dependent(:destroy)
                                      .with_foreign_key('author_id')
    end
    it do should have_many(:answers).dependent(:destroy)
                                    .with_foreign_key('author_id')
    end
    it do should have_many(:comments).dependent(:destroy)
                                     .with_foreign_key('author_id')
    end

    it { should have_many(:votes).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  describe 'methods' do
    context '#is_author?' do
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

    context 'voting methods' do
      let(:voted_question) { create(:question) }
      let(:question) { create(:question) }
      let(:user) { create(:user) }

      context '#vote' do
        it 'resource has user vote' do
          vote = create(:vote, votable: voted_question, author: user, up: true)
          expect(user.vote(voted_question)).to eq vote
        end
      end

      context '#voted_from?' do
        it 'user has been vote on question later' do
          create(:vote, votable: voted_question, author: user, up: true)
          expect(user.voted_for?(voted_question)).to be_truthy
        end
      end
    end
  end
end
