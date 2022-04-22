require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) {  { "CONTENT_TYPE" => "application/json",
                     "ACCEPT" => 'application/json' } }

  describe 'GET /api/v1/profiles/me' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles/me' }
    end

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles/me', headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/profiles/me', params: { access_token: '1234' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json['user'][attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /profiles' do
    let(:api_path) { '/api/v1/profiles' }
    let(:method) { :get }
    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:users) { create_list(:user, 5) }
      let(:user) { users[1] }
      let(:me) { users.first }
      let(:access_token) { create :access_token, resource_owner_id: me.id }
      let(:user_responce) { json['users'].first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'return all users except author' do
        response_ids = User.where.not(id: me.id).ids

        expect(json['users'].size).to eq users.size - 1
        expect(response_ids).to_not include(me.id)
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(user_responce[attr]).to eq user.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(user_responce).to_not have_key(attr)
        end
      end
    end
  end
end
