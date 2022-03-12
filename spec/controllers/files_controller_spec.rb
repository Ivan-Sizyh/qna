require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  describe 'DELETE #destroy' do
    let!(:question) { create(:question, :with_files) }
    let(:file) { question.files.first }

    context 'User is author' do
      before { login(question.author) }

      it 'deletes the file' do
        expect { delete :destroy, params: { id: file }, format: :js }.to change(question.files, :count).by(-1)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: file }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'User is not author' do
      let(:user) { create(:user) }
      before { login(user) }

      it 'not deletes file' do
        expect { delete :destroy, params: { id: file }, format: :js }.to_not change(Answer, :count)
      end

      it 're-render question' do
        delete :destroy, params: { id: file }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end
end
