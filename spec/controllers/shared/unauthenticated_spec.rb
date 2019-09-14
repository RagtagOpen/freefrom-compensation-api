require_relative './spec_helpers'

RSpec.shared_examples "an unauthenticated object" do |model|
  let(:id) { 1000 }

  describe '#show' do
    context "where #{model.to_s} exists" do
      before do
        create(factory_name(model), id: id)
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
end