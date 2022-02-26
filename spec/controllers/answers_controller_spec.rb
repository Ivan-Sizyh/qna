require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST #create' do
    let(:answer) { create(:answer) }
    let(:question) { create(:question) }
    let(:user) { create(:user) }

    before { login(user) }

    context 'with valid attributes' do
      it 'add an answer to a question' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to change(question.answers, :count).by(1)
      end

      it 'render question show view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to assigns(:exposed_question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }.to_not change(Answer, :count)
      end

      it 're-renders show new view' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer) }
    let!(:question) { create(:question) }

    before { login(answer.author) }

    it 'deletes the answer' do
      expect { delete :destroy, params: { id: answer, question_id: question } }.to change(Answer, :count).by(-1)
    end

    it 'redirects to question' do
      delete :destroy, params: { id: answer, question_id: question }
      expect(response).to redirect_to question
    end
  end
end
