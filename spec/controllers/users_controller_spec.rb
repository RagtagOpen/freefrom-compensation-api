require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe '#current' do
    let(:email) { 'adalovelace@lovelace.net' }
    let(:username) { 'ada' }
    let(:role) { 'user' }

    let(:user) { create(:user, email: email, username: username, role: role) }
    let(:token) { Knock::AuthToken.new(payload: { sub: user.id }).token }

    let(:headers) do
      {
        'Authorization': "Bearer #{token}"
      }
    end

    context 'there is a logged in user' do
      it 'returns 200 and the user information' do
        request.headers.merge! headers
        get :current
        expect(response.status).to eq(200)

        body = JSON.parse(response.body)
        expect(body['id']).to be_a(Integer)
        expect(body['email']).to eq(email)
        expect(body['username']).to eq(username)
        expect(body['role']).to eq(role)
        expect(body['password_digest']).to be_nil
      end
    end

    context 'there is no logged in user' do
      it 'returns 401 and an empty body' do
        get :current
        expect(response.status).to eq(401)

        body = JSON.parse(response.body)
        expect(body).to be_empty
      end
    end
  end
end
