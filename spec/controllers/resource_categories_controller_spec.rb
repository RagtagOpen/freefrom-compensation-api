require 'rails_helper'
require 'spec_helper'

describe ResourceCategoriesController, type: :controller do
  describe '#show' do
    let(:id) { 1000 }

    context 'where resource category exists' do
      before do
        resource_category = build(:resource_category, id: id)
        resource_category.save!
      end

      it 'returns 200 and the resource category' do
        get :show, params: { id: id }
        expect(response.status).to eq(200)

        body = JSON.parse(response.body)
        expect(body['id']).to eq(id)
      end
    end

    context 'where the resource category doesn\'t exist' do
      it 'returns 404' do
        get :show, params: { id: id }
        expect(response.status).to eq(404)
      end
    end
  end

  describe '#create' do
    it 'returns 201 and the resource category' do
      post :create
      expect(response.status).to eq(201)

      body = JSON.parse(response.body)
      expect(body).to have_key('id')
    end
  end
end
