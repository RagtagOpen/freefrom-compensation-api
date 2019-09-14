require_relative './spec_helpers'

RSpec.shared_examples "an unauthenticated object" do |model, params=nil|
  let(:id) { 1000 }

  describe '#show' do
    context "where #{model.to_s} exists" do
      before do
        create(factory_name(model), :valid, id: id)
      end

      it "returns 200 and the #{model.to_s}" do
        get :show, params: { id: id }
        expect(response.status).to eq(200)

        body = JSON.parse(response.body)
        expect(body['id']).to eq(id)
      end
    end

    context "where #{model.to_s} does not exist" do
      it 'returns 404' do
        get :show, params: { id: id }
        expect(response.status).to eq(404)
      end
    end
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

  describe '#update' do
    it 'returns 401' do
      put :update, params: { id: id }
      expect(response.status).to eq(401)
    end
  end
end