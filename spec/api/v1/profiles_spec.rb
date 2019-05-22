require 'rails_helper'

describe 'Profiles API', type: :request do
  describe 'GET /profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }
    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get api_path, params: { access_token: access_token.token }, headers: oauth_headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns public fields' do
        %w[id email created_at updated_at].each do |attr|
          expect(json['user'][attr]).to eq me.send(attr).as_json
        end
      end

      it 'doesnt return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json['user']).to_not have_key attr
        end
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    it_behaves_like 'API authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles' }
    end

    context 'authorized' do
      let!(:users) { create_list(:user, 3) }
      let!(:oauth_user) { users.first }
      let(:users_response) { json['users'] }
      let(:access_token) { create(:access_token, resource_owner_id: oauth_user.id) }

      before { get '/api/v1/profiles', params: { access_token: access_token.token }, headers: oauth_headers }

      it 'returns 200 OK status' do
        expect(response).to be_successful
      end

      it 'returns list of user profiles' do
        expect(users_response.size).to eq 2
      end

      it 'does not return initial user' do
        expect(users_response).to_not include oauth_user
      end

      it 'returns all public fields' do
        %w[id email created_at updated_at].each do |attr|
          expect(users_response.last[attr]).to eq users.last.send(attr).as_json
        end
      end

      it 'does not return private fields of users' do
        %w[password encrypted_password].each do |attr|
          expect(users_response.first).to_not have_key(attr)
        end
      end
    end
  end
end
