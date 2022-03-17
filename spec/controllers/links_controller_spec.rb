require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }
    let!(:link) { create(:link, name: 'youtube', url: 'https://www.youtube.com', linkable: question) }

    context 'User is author' do
      before { login(question.author) }

      it 'deletes the file' do
        expect { delete :destroy, params: { id: link }, format: :js }.to change(question.links, :count).by(-1)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: link }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'User is not author' do
      let(:user) { create(:user) }
      before { login(user) }

      it 'not deletes file' do
        expect { delete :destroy, params: { id: link }, format: :js }.to_not change(Link, :count)
      end

      it 're-render question' do
        delete :destroy, params: { id: link }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end
end
