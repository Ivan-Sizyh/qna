require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'POST #create' do
    let(:answer) { create(:answer) }
    let(:user) { create(:user) }

    before { login(user) }

    context 'with valid attributes' do
      it 'add an answer to a question' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'render question show view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }.to_not change(Answer, :count)
      end

      it 're-renders show new view' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question) }
    let(:user) { create(:user) }

    before { login(user) }

    context 'User is author' do
      before { login(answer.author) }

      context 'with valid attributes' do
        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: "new body" }, question_id: answer.question }, format: :js

          answer.reload

          expect(answer.body).to eq 'new body'
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: { body: 'new body' }, question_id: answer.question }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'does not change answer attributes' do
          expect do
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), question_id: answer.question }, format: :js
          end.to_not change(answer, :body)
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), question_id: answer.question }, format: :js
          expect(response).to render_template :update
        end
      end
    end

    context 'User is not author' do
      it 'does not change the answer' do
        old_answer = answer

        patch :update, params: { id: answer, answer: { body: 'new body' }, question_id: answer.question }, format: :js
        answer.reload

        expect(answer.body).to eq old_answer.body
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer) }
    let!(:question) { create(:question) }

    context 'User is author' do
      before { login(answer.author) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer, question_id: question }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: answer, question_id: question }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'User is not author' do
      let(:user) { create(:user) }
      before { login(user) }

      it 'not deletes the answer' do
        expect { delete :destroy, params: { id: answer, question_id: question }, format: :js }.to_not change(Answer, :count)
      end

      it 're-render answer' do
        delete :destroy, params: { id: answer, question_id: question }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end
end
