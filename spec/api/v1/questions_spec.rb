require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) {{"CONTENT_TYPE" => "application/json",
                  "ACCEPT" => 'application/json'}}

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) {create(:access_token)}
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get api_path, params: {access_token: access_token.token}, headers: headers }

      it 'returns successful status' do
        expect(response).to be_successful
      end

      it 'returns all questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains author object' do
        expect(question_response['author']['id']).to eq question.author.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body author_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/show' do
    let!(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}"}

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:question) { create(:question) }
      let(:question_response) { json['question'] }
      let!(:links) { create_list(:link, 2, linkable: question) }
      let!(:comments) { create_list(:comment, 2, commentable: question) }

      before do
        question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
        question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'spec_helper.rb')

        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns successful status' do
        expect(response).to be_successful
      end

      it_behaves_like 'API Add Link' do
        let(:links_response) { question_response['links'] }
        let(:link) { links.first }
      end

      it_behaves_like 'API File Attach' do
        let(:files_response) { question_response['files'] }
      end

      it_behaves_like 'API Add Comment' do
        let(:comments_response) { question_response['comments'] }
        let(:comment) { comments.first }
      end
    end
  end

  describe 'POST /api/v1/questions/create' do
    let(:headers) { { "ACCEPT" => "application/json" } }
    let(:access_token) { create(:access_token) }
    let(:api_path) { "/api/v1/questions" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'Authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }

      context 'Valid attributes' do
        it 'create a new question' do
          expect{ post api_path, params: { access_token: access_token.token, question: attributes_for(:question) },
                       headers: headers }.to change(Question, :count).by(1)
        end

        it 'return successful status' do
          post api_path, params: { access_token: access_token.token, question: attributes_for(:question) }, headers: headers
          expect(response).to be_successful
        end

        it 'returns question fields' do
          post api_path, params: { access_token: access_token.token, question: attributes_for(:question) },
               headers: headers

          %w[id title body created_at updated_at].each do |attr|
            expect(question_response[attr]).to eq assigns(:exposed_question).send(attr).as_json
          end
        end
      end

      context 'Invalid attributes' do
        it 'does not save new question' do
          expect{ post api_path, params: { access_token: access_token.token, question: attributes_for(:question, :invalid) },
                       headers: headers }.to_not change(Question, :count)
        end

        it 'returns unprocessable_entity' do
          post api_path, params: { access_token: access_token.token, question: attributes_for(:question, :invalid) }, headers: headers
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/update' do
    let(:headers) { { "ACCEPT" => "application/json" } }

    let(:access_token) { create(:access_token) }
    let(:question) { create(:question, author_id: access_token.resource_owner_id) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like "API Authorizable" do
      let(:method) { :patch }
    end

    context 'authorized' do

      context 'valid attributes' do
        it 'edits the question' do
          patch api_path, params: { access_token: access_token.token, question: { title: 'Edit question', body: 'Edit body' } }, headers: headers
          question.reload
          expect(question.title).to eq 'Edit question'
        end

        it 'returns successful status' do
          patch api_path, params: { access_token: access_token.token, question: attributes_for(:question) }, headers: headers
          expect(response).to be_successful
        end
      end

      context 'invalid attributes' do
        it "doesn't edits the question" do
          patch api_path, params: { access_token: access_token.token, question: { title: nil, body: 'invalid data' } }, headers: headers
          question.reload
          expect(question.title).to_not eq 'invalid data'
        end

        it 'returns unprocessable_entity' do
          patch api_path, params: { access_token: access_token.token, question: attributes_for(:question, :invalid) }, headers: headers
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/question' do
    let(:headers) { { "ACCEPT" => "application/json" } }

    let(:access_token) { create(:access_token) }
    let(:question) { create(:question, author_id: access_token.resource_owner_id) }
    let(:questions) { question.author.questions }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like "API Authorizable" do
      let(:method) { :delete }
    end

    context 'authorized' do
      it 'deletes the question' do
        expect { delete api_path, params: { access_token: access_token.token }, headers: headers }.to change(questions, :count).by(-1)
      end

      it 'returns successful status' do
        delete api_path, params: { access_token: access_token.token }, headers: headers
        expect(response).to be_successful
      end
    end
  end
end
