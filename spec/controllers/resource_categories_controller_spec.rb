require 'rails_helper'
require_relative './shared/unauthenticated_spec'

describe ResourceCategoriesController, type: :controller do
  it_behaves_like 'an unauthenticated object', ResourceCategory

  describe '#index' do
    context 'where resource categories exist' do
      let!(:resource_category1) { create(:resource_category) }
      let!(:resource_category2) { create(:resource_category) }

      it 'returns all resource_category' do
        get :index
        expect(response.status).to eq(200)

        body = JSON.parse(response.body)
        expect(body.length).to eq(2)
      end
    end

    context 'where no resource categories exist' do
      it 'returns an empty array' do
        get :index
        expect(response.status).to eq(200)

        body = JSON.parse(response.body)
        expect(body).to be_a(Array)
        expect(body).to be_empty
      end
    end
  end

  context 'with admin user' do
    setup_admin_controller_spec

    describe '#create' do
      it 'returns 201 and the resource category' do
        post :create
        expect(response.status).to eq(201)

        body = JSON.parse(response.body)
        expect(body['id']).to be_a(Integer)
      end
    end

    describe '#destroy' do
      before do
        create(:resource_category, id: id)
      end

      it 'returns 204 and an empty body' do
        delete :destroy, params: { id: id }
        expect(response.status).to eq(204)

        body = JSON.parse(response.body)
        expect(body).to be_empty
      end
    end

    describe '#update' do
      context 'where resource category doesn\'t exist' do
        it 'returns 404 and an empty body' do
          put :update, params: { id: id }
          expect(response.status).to eq(404)

          body = JSON.parse(response.body)
          expect(body).to be_empty
        end
      end

      context 'where resource category does exist' do
        let(:resource_category) { build(:resource_category, id: id) }

        before do
          resource_category.save!
        end

        context 'and update succeeds' do
          let(:params) do
            {
              name: 'New name',
              description: 'New description',
              slug: 'resource_category_slug'
            }
          end

          it 'returns 200 and new resource category' do
            put :update, params: params.merge(id: id)
            expect(response.status).to eq(200)

            body = JSON.parse(response.body)

            params.keys.each do |key|
              expect(body[key.to_s]).to eq(params[key.to_sym])
            end
          end

          context 'only altering one field' do
            let(:new_name) { 'New name' }
            let(:old_description) { 'Here\'s a description I want to keep' }
            let(:params) { { name: new_name } }

            before do
              resource_category.description = old_description
              resource_category.save!
            end

            it 'updates the fields passed into the params and does not modify anything else' do
              put :update, params: params.merge(id: id)
              expect(response.status).to eq(200)

              body = JSON.parse(response.body)
              expect(body['name']).to eq(new_name)
              expect(body['description']).to eq(old_description)
            end
          end
        end
      end
    end
  end
end
