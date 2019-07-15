require 'rails_helper'
require 'spec_helper'

describe ResourceCategoriesController, type: :controller do
  describe '#show' do
    context 'where resource category exists' do
      it 'returns 200 and the resource category' do
        get :show, params: { id: 'id' }
        expect(response.status).to eq(200)
        # TODO: expect response body
      end
    end

    context 'where the resource category doesn\'t exist' do

    end
  end
end
