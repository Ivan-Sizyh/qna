require 'rails_helper'

RSpec.shared_examples_for "voted" do
  let(:model_name) {  described_class.controller_name }
  let(:model) { create(model_name.singularize) }
  let(:user) { create(:user) }

  describe "POST #vote" do
    context 'User is author model' do
      before { login(model.author) }

      it 'didnt create vote' do
        expect { post :vote, params: { id: model, up: true, votable: model_name, format: :json } }.to_not change(model.votes, :count)
      end
    end

    context 'User is not author model' do
      before { login(user) }

      it 'create vote' do
        expect { post :vote, params: { id: model, up: true, votable: model_name, format: :json } }.to change(model.votes, :count).by(1)
      end

      it 'render model with stats' do
        post :vote, params: { id: model, up: true, votable: model_name, format: :json }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "DELETE #unvote" do
    it 'user is author vote' do
      login(user)

      post :vote, params: { id: model, up: true, votable: model_name }
      expect { delete :unvote, params: { id: model, votable: model_name, format: :json } }.to change(model.votes, :count).by(-1)
    end

    it 'user is not author vote' do
      diff_user = create(:user)
      login(diff_user)

      expect { delete :unvote, params: { id: model, votable: model_name, format: :json } }.to_not change(model.votes, :count)
    end
  end
end