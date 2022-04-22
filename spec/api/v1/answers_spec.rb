require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => 'application/json' } }

  let!(:question) { create(:question, :with_answers) }

  describe 'GET /api/v1/questions/question/answers' do
    let!(:answers) { question.answers }
    let(:answers_count) { answers.count }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers"}

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answers'].first }
      let(:answer) { answers.first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns question answers' do
        expect(json['answers'].size).to eq answers_count
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'contains author object' do
        expect(answer_response['author']['id']).to eq answer.author.id
      end
    end
  end

  describe 'GET /api/v1/answers/show' do
    let(:answer) { question.answers.first }
    let(:api_path) { "/api/v1/answers/#{answer.id}"}

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answer'] }
      let!(:links) { create_list(:link, 2, linkable: answer) }
      let!(:comments) { create_list(:comment, 2, commentable: answer) }

      before do
        answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
        answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'spec_helper.rb')

        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it_behaves_like 'API Add Link' do
        let(:links_response) { answer_response['links'] }
        let(:link) { links.first }
      end

      it_behaves_like 'API File Attach' do
        let(:files_response) { answer_response['files'] }
      end

      it_behaves_like 'API Add Comment' do
        let(:comments_response) { answer_response['comments'] }
        let(:comment) { comments.first }
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end
    end
  end

  describe 'POST /api/v1/questions/answers' do
    let(:headers) { { "ACCEPT" => "application/json" } }

    let(:access_token) { create(:access_token) }
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'Authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answer'] }

      context 'valid attributes' do
        it 'create a new question' do
          expect{ post api_path, params: { access_token: access_token.token, answer: attributes_for(:answer) },
                       headers: headers }.to change(Answer, :count).by(1)
        end

        it 'return successful status' do
          post api_path, params: { access_token: access_token.token, answer: attributes_for(:answer) }, headers: headers
          expect(response).to be_successful
        end

        it 'returns answer fields' do
          post api_path, params: { access_token: access_token.token, answer: attributes_for(:answer) }, headers: headers

          %w[id body created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq assigns(:exposed_answer).send(attr).as_json
          end
        end
      end

      context 'invalid attributes' do
        it 'does not save new answer' do
          expect{ post api_path, params: { access_token: access_token.token, answer: attributes_for(:answer, :invalid) },
                       headers: headers }.to_not change(Answer, :count)
        end

        it 'returns unprocessable_entity status' do
          post api_path, params: { access_token: access_token.token, answer: attributes_for(:answer, :invalid) },
               headers: headers
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:headers) { { "ACCEPT" => "application/json" } }
    let(:access_token) { create(:access_token) }
    let(:answer) { create(:answer, author_id: access_token.resource_owner_id) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like "API Authorizable" do
      let(:method) { :patch }
    end

    context 'authorized' do
      context 'with valid attributes' do
        it 'edits the answer' do
          patch api_path, params: { access_token: access_token.token, answer: { body: 'Edited answer' } },
                headers: headers
          answer.reload

          expect(answer.body).to eq 'Edited answer'
        end

        it 'returns successful status' do
          patch api_path, params: { access_token: access_token.token, answer: attributes_for(:answer) },
                headers: headers
          answer.reload

          expect(response).to be_successful
        end
      end

      context 'with invalid attributes' do
        it "doesn't edits the answer" do
          patch api_path, params: { access_token: access_token.token, answer: attributes_for(:answer, :invalid) },
                headers: headers
          before_answer = answer
          answer.reload
          expect(answer.body).to eq before_answer.body
        end

        it 'returns unprocessable_entity' do
          patch api_path, params: { access_token: access_token.token, answer: attributes_for(:answer, :invalid) },
                headers: headers
          answer.reload
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:headers) { { "ACCEPT" => "application/json" } }

    let(:access_token) { create(:access_token) }
    let(:answer) { create(:answer, author_id: access_token.resource_owner_id) }
    let(:answers) { answer.author.answers }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like "API Authorizable" do
      let(:method) { :delete }
    end

    context 'authorized' do
      it 'deletes the answer' do
        expect { delete api_path, params: { access_token: access_token.token }, headers: headers }
          .to change(answers, :count).by(-1)
      end

      it 'returns successful status' do
        expect { delete api_path, params: { access_token: access_token.token }, headers: headers }
        expect(response).to have_http_status 200
      end
    end
  end
end
