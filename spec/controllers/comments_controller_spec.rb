require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe 'POST #create' do
    let!(:question) { create(:question) }
    let!(:user) { create(:user) }

    before { sign_in(user) }

    describe 'with valid attributes' do
      it 'should create comment' do
        expect { post :create,
                      params: { comment: { text: 'Test Body' }, commentable_type: question.class.to_s, commentable_id: question.id },
                      format: :js }.to change(Comment, :count).by(1)
      end

      it 'should render :create template' do
        post :create,
             params: { comment: { text: 'Test Body' }, commentable_type: question.class.to_s, commentable_id: question.id },
             format: :js

        expect(response).to render_template :create
      end
    end

    describe 'with invalid attributes' do
      it 'should not create comment' do
        expect { post :create,
                      params: { comment: { text: ''}, commentable_type: question.class.to_s, commentable_id: question.id },
                      format: :js }.to_not change(Comment, :count)
      end

      it 'should render :create template' do
        post :create, params: { comment: { text: ''}, commentable_type: question.class.to_s, commentable_id: question.id }, format: :js
        expect(response).to render_template :create
      end
    end
  end
end
