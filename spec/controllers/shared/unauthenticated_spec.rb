require_relative './helpers'

RSpec.shared_examples 'an unauthenticated object' do |model, params = {}|
  let(:id) { 1000 }

  describe '#show' do
    context "where #{model} exists" do
      before do
        create(factory_name(model), :valid, id: id)
      end

      it "returns 200 and the #{model}" do
        get :show, params: { id: id }
        expect(response.status).to eq(200)

        body = JSON.parse(response.body)
        expect(body['id']).to eq(id)
      end
    end

    context "where #{model} does not exist" do
      it 'returns 404' do
        get :show, params: { id: id }
        expect(response.status).to eq(404)
      end
    end
  end

  # When unauthenticated, create/destroy/update routes redirect
  describe '#create' do
    let(:create_params) { params[:create] || {} }

    it 'returns 302' do
      post :create, params: create_params
      expect(response.status).to eq(302)
    end
  end

  describe '#destroy' do
    it 'returns 302' do
      delete :destroy, params: { id: id }
      expect(response.status).to eq(302)
    end
  end

  describe '#update' do
    it 'returns 302' do
      put :update, params: { id: id }
      expect(response.status).to eq(302)
    end
  end
end
