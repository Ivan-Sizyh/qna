require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'associations' do
    it { should belong_to :question }
    it { should belong_to(:author).class_name('User') }
  end

  describe 'validations' do
    it { should validate_presence_of :body }
  end

  describe 'methods' do
    context 'unset_best_answer method' do
      let(:question) { create(:question, :with_answers) }
      let(:user) { question.author }
      let(:best_answer) { question.best_answer }

      before do
        question.best_answer = question.answers.first
      end

      it 'answer is best_answer' do
        best_answer.destroy
        expect(question.best_answer).to eq nil
      end

      it 'answer is not best_answer' do
        another_answer = question.answers.last
        another_answer.destroy
        expect(question.best_answer).to eq best_answer
      end
    end
  end
end
