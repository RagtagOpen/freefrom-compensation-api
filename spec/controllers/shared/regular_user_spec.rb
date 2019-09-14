require_relative './helpers'

RSpec.shared_examples "an object authenticated with a regular user" do |model, params={}|
  let(:id) { 1000 }
  let(:user) { create(:user) }
  let(:token) { Knock::AuthToken.new(payload: { sub: user.id }).token }
  let(:headers) { { 'Authorization': "Bearer #{token}" } }

  before do
    request.headers.merge! headers
  end

  describe '#create' do
    let(:create_params) { params[:create] || {} }

    it 'returns 401' do
      post :create, params: create_params
      expect(response.status).to eq(401)
    end
  end

  describe '#destroy' do
    it 'returns 401' do
      delete :destroy, params: { id: id }
      expect(response.status).to eq(401)
    end
  end

  describe  '#update' do
    it 'returns 401' do
      put :update, params: { id: id }
      expect(response.status).to eq(401)
    end
  end
end
