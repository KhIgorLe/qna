require 'rails_helper'

describe 'Profiles Api', type: :request do
  let(:headers) {  { "CONTENT_TYPE" => "application/json",
                     "ACCEPT" => 'application/json' } }
  let(:method) { 'get' }

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'Api Authorizable'

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:json_user) { json['user'] }
      let(:keys) { %w[id email admin created_at updated_at] }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it_behaves_like 'Return response status', 200

      it_behaves_like 'Return all public fields', 'json_user', 'me'

      it 'not returns all private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  describe 'get /api/v1/profiles' do
    let(:api_path) { '/api/v1/profiles' }

    it_behaves_like 'Api Authorizable'

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:users) { create_list(:user, 2) }
      let(:user) { users.first }
      let(:keys) { %w[id email admin created_at updated_at] }
      let(:json_users) { json['users'] }
      let(:json_user) { json_users.first }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it_behaves_like 'Return response status', 200

      it_behaves_like 'Return list objects', 2, 'json_users'

      it_behaves_like 'Return all public fields', 'json_user', 'user'

      it 'not return authenticated user' do
        json_users.each do |user|
          expect(user['id']).to_not eq me.id.as_json
        end
      end
    end
  end
end
