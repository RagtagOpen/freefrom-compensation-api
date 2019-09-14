require 'rails_helper'
require_relative './shared/unauthenticated_spec'
require_relative './shared/regular_user_spec'

describe ResourceLinksController, type: :controller do
  it_behaves_like 'an unauthenticated object', ResourceLink, create: { resource_id: 123 }
  it_behaves_like 'an object authenticated with a regular user', create: { resource_id: 123 }

  describe 'with admin user' do
    setup_admin_controller_spec

    describe '#create' do
      let!(:resource) { create(:resource, :with_resource_category) }
      let(:resource_id) { resource.id.to_i }

      let(:params) { { resource_id: resource_id } }

      context 'an invalid resource id' do
        let(:resource_id) { 'fake-id' }

        it 'returns 400 and an error' do
          post :create, params: params
          expect(response.status).to eq(400)

          body = JSON.parse(response.body)
          expect(body['error']).to eq('Validation failed: Resource must exist')
        end
      end

      it 'returns 201 and the resource link' do
        post :create, params: params
        expect(response.status).to eq(201)

        body = JSON.parse(response.body)
        expect(body['id']).to be_a(Integer)
        expect(body['resource_id']).to eq(resource_id)
      end
    end

    describe '#destroy' do
      before do
        create(:resource_link, :with_resource, id: id)
      end

      it 'returns 204 and an empty body' do
        delete :destroy, params: { id: id }
        expect(response.status).to eq(204)

        body = JSON.parse(response.body)
        expect(body).to be_empty
      end
    end

    describe '#update' do
      context 'where resource link doesn\'t exist' do
        it 'returns 404 and an empty body' do
          put :update, params: { id: id }
          expect(response.status).to eq(404)

          body = JSON.parse(response.body)
          expect(body).to be_empty
        end
      end

      context 'where resource link does exist' do
        let!(:resource_link) { create(:resource_link, :with_resource, id: id) }
        let!(:new_resource) { create(:resource, :with_resource_category) }

        context 'and update succeeds' do
          let(:params) do
            {
              description: 'link description',
              url: 'https://freefrom.org',
              resource_id: new_resource.id.to_i
            }
          end

          it 'returns 200 and new resource' do
            put :update, params: params.merge(id: id)
            expect(response.status).to eq(200)

            body = JSON.parse(response.body)

            params.each do |key, value|
              expect(body[key.to_s]).to eq(value)
            end
          end

          context 'only altering one field' do
            let(:new_description) { 'New resource link description' }
            let(:old_url) { 'https://google.com' }
            let(:params) { { description: new_description } }

            before do
              resource_link.url = old_url
              resource_link.save!
            end

            it 'updates the fields passed into the params and does not modify anything else' do
              put :update, params: params.merge(id: id)
              expect(response.status).to eq(200)

              body = JSON.parse(response.body)
              expect(body['description']).to eq(new_description)
              expect(body['url']).to eq(old_url)
            end
          end
        end
      end
    end
  end
end
