require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let!(:user) { create(:user) }
  before { login(user) }

  describe 'POST #create' do
    let(:question) { create(:question) }
    let(:user) { create(:user) }

    context 'with valid attributes' do
      it 'saves a new subscription in the database' do
        expect { post :create, params: { question_id: question, user_id: user }, format: :js }.to change(Subscription, :count).by(1)
      end

      it 'return successful status' do
        post :create, params: { question_id: question, user_id: user }, format: :js
        expect(response).to be_successful
      end
    end

    context 'with invalid attributes' do
      it 'does not save the subscription' do
        expect { post :create, params: { question_id: attributes_for(:question, :invalid), user_id: user }, format: :js }
          .to_not change(Subscription, :count)
      end

      it 're-render template' do
        post :create, params: { question_id: attributes_for(:question, :invalid), user_id: user }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, :with_subscription) }
    let(:subscription) { question.subscriptions.first }

    context 'User is subscribed' do
      before { login(subscription.user) }

      it 'deletes the subscription' do
        expect { delete :destroy, params: { id: subscription }, format: :js }.to change(question.subscriptions, :count).by(-1)
      end

      it 're-render question' do
        delete :destroy, params: { id: subscription }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'User is not subscribed' do
      let(:user) { create(:user) }
      before { login(user) }

      it 'not deletes subscription' do
        expect { delete :destroy, params: { id: subscription }, format: :js }.to_not change(question.subscriptions, :count)
      end
    end
  end
end
