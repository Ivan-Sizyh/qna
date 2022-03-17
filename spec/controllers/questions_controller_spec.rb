require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  before { login(user) }

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns new link for answer' do
      expect(assigns(:exposed_answer).links.first).to be_a_new(Link)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'assigns a new link to question' do
      expect(assigns(:exposed_question).links.first).to be_a_new(Link)
    end

    it 'assigns a new rewards to question' do
      expect(assigns(:exposed_question).reward).to be_a_new(Reward)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:exposed_question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end
      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'User is author' do
      before { login(question.author) }

      context 'with valid attributes' do
        it 'change question attributes' do
          patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
          question.reload

          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'render updated question' do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        before do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
        end

        it 'does not change question' do
          old_question = question

          question.reload

          expect(question.title).to eq old_question.title
          expect(question.body).to eq old_question.body
        end

        it 're-renders edit update view' do
          expect(response).to render_template :update
        end
      end
    end

    context 'User is not author' do
      it 'does not change the question' do
        old_question = question

        patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
        question.reload

        expect(question.title).to eq old_question.title
        expect(question.body).to eq old_question.body
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }

    context 'User is author' do
      before { login(question.author) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'User is not author' do
      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to question
      end
    end
  end

  describe 'PATCH #set_best_answer' do
    let(:answer) { create(:answer) }
    let!(:reward) { create(:reward, question: question) }
    context 'User is author' do
      before { login(question.author) }

      context 'with valid attributes' do
        it 'change question attributes' do
          patch :set_best_answer, params: { id: question.id, answer_id: answer.id, format: :js }
          question.reload
          reward.reload

          expect(question.best_answer).to eq answer
          expect(reward.user).to eq answer.author
        end

        it 'render updated question' do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
          expect(response).to render_template :update
        end
      end
    end

    context 'User is not author' do
      it 'does not change the question' do
        old_question = question

        patch :set_best_answer, params: { id: question.id, answer_id: answer.id, format: :js }
        question.reload
        reward.reload

        expect(question.best_answer).to eq old_question.best_answer
        expect(question.reward.user).to eq old_question.reward.user
      end
    end
  end
end
