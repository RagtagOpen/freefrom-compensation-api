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
      expect(body['id']).to be_a(Integer)
    end
  end

  describe '#destroy' do
    let(:id) { 1000 }

    before do
      resource_category = build(:resource_category, id: id)
      resource_category.save!
    end

    it 'returns 204 and an empty body' do
      delete :destroy, params: { id: id }
      expect(response.status).to eq(204)

      body = JSON.parse(response.body)
      expect(body).to be_empty
    end
  end

  describe '#update' do
    let(:id) { 1000 }

    context 'where resource category doesn\'t exist' do
      it 'returns 404 and an empty body' do
        put :update, params: { id: id }
        expect(response.status).to eq(404)

        body = JSON.parse(response.body)
        expect(body).to be_empty
      end
    end

    context 'where resource category does exist' do
      before do
        resource_category = build(:resource_category, id: id, seo_keywords: [])
        resource_category.save!
      end

      context 'and update succeeds' do
        let(:params) do
          {
            name: 'New name',
            short_description: 'New short description',
            description: 'New description',
            # icon: icon,
            seo_title: 'New SEO title',
            seo_description: 'New SEO description',
            seo_keywords: ['keyword1', 'keyword2', 'keyword3'],
            # share_image: share_image,
          }
        end

        it 'returns 200 and new resource category' do
          put :update, params: params.merge({ id: id })
          expect(response.status).to eq(200)

          body = JSON.parse(response.body)
          keys = %w(description name seo_description seo_keywords seo_title short_description)

          keys.each do |key|
            expect(body[key]).to eq(params[key.to_sym])
          end
        end
      end
    end
  end
end
