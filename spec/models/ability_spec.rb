require 'rails_helper'
require "cancan/matchers"

describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }

    let(:question) { create(:question, :with_files, author: user) }
    let(:file) { question.files.first }


    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, create(:question, author: user) }
    it { should_not be_able_to :update, create(:question, author: other) }

    it { should be_able_to :update, create(:answer, author: user) }
    it { should_not be_able_to :update, create(:answer, author: other) }

    it { should be_able_to :destroy, create(:question, author: user) }
    it { should_not be_able_to :destroy, create(:question, author: other) }

    it { should be_able_to :destroy, create(:answer, author: user) }
    it { should_not be_able_to :destroy, create(:answer, author: other) }

    it { should be_able_to :set_best_answer, create(:question, author: user) }

    it { should be_able_to :destroy, file }
    it { should be_able_to :destroy, create(:link, linkable: question) }

    context 'voting' do
      context 'vote' do
        it { should be_able_to :vote, create(:question, author: other) }
        it { should_not be_able_to :vote, create(:question, author: user) }
      end

      context 'unvote' do
        it do
          create(:vote, votable: question, author: question.author, up: 1)

          should be_able_to :unvote, question
        end

        it { should_not be_able_to :unvote, create(:question, author: other) }
      end
    end

    it { should be_able_to :create, Subscription }
    it { should be_able_to :destroy, Subscription }
  end
end
