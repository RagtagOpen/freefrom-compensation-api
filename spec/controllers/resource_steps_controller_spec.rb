require 'rails_helper'
require_relative './shared/unauthenticated_spec'
require_relative './shared/regular_user_spec'

describe ResourceStepsController, type: :controller do
  it_behaves_like 'an unauthenticated object', ResourceStep, create: { resource_id: 123, number: 1 }
  it_behaves_like 'an object authenticated with a regular user', create: { resource_id: 123, number: 1 }

  describe 'with admin user' do
    setup_admin_controller_spec

    describe '#create' do
      let!(:resource) { create(:resource, :with_resource_category) }
      let(:resource_id) { resource.id.to_i }
      let(:number) { 1 }

      let(:params) { { resource_id: resource_id, number: number } }

      context 'an invalid resource id' do
        let(:resource_id) { 'fake-id' }

        it 'returns 400 and an error' do
          post :create, params: params
          expect(response.status).to eq(400)

          body = JSON.parse(response.body)
          expect(body['error']).to eq('Validation failed: Resource must exist')
        end
      end

      context 'without number' do
        let(:number) { nil }

        it 'returns 400 and an error' do
          post :create, params: params
          expect(response.status).to eq(400)

          body = JSON.parse(response.body)
          expect(body['error']).to eq('Missing number parameter')
        end
      end

      it 'returns 201 and the resource step' do
        post :create, params: params
        expect(response.status).to eq(201)

        body = JSON.parse(response.body)
        expect(body['id']).to be_a(Integer)
        expect(body['resource_id']).to eq(resource_id)
        expect(body['number']).to eq(number)
      end
    end

    describe '#destroy' do
      before do
        create(:resource_step, :with_resource, id: id)
      end

      it 'returns 204 and an empty body' do
        delete :destroy, params: { id: id }
        expect(response.status).to eq(204)

        body = JSON.parse(response.body)
        expect(body).to be_empty
      end
    end

    describe '#update' do
      context 'where resource step doesn\'t exist' do
        it 'returns 404 and an empty body' do
          put :update, params: { id: id }
          expect(response.status).to eq(404)

          body = JSON.parse(response.body)
          expect(body).to be_empty
        end
      end

      context 'where resource step does exist' do
        let!(:resource_step) { create(:resource_step, :with_resource, id: id) }
        let!(:new_resource) { create(:resource, :with_resource_category) }

        context 'and update succeeds' do
          let(:params) do
            {
              description: 'resource step description',
              number: 1,
              resource_id: new_resource.id.to_i
            }
          end

          it 'returns 200 and new resource' do
            put :update, params: params.merge(id: id)
            expect(response.status).to eq(200)

            body = JSON.parse(response.body)
            keys = %w[description number resource_id]

            keys.each do |key|
              expect(body[key]).to eq(params[key.to_sym])
            end
          end

          context 'only altering one field' do
            let(:new_description) { 'New resource step description' }
            let(:old_number) { 1 }
            let(:params) { { description: new_description } }

            before do
              resource_step.number = old_number
              resource_step.save!
            end

            it 'updates the fields passed into the params and does not modify anything else' do
              put :update, params: params.merge(id: id)
              expect(response.status).to eq(200)

              body = JSON.parse(response.body)
              expect(body['description']).to eq(new_description)
              expect(body['number']).to eq(old_number)
            end
          end

          context 'with an invalid field' do
            let(:new_number) { nil }
            let(:params) { { number: new_number } }

            it 'returns 400 and an error message' do
              put :update, params: params.merge(id: id)
              expect(response.status).to eq(400)

              body = JSON.parse(response.body)
              expect(body['error']).to eq("Validation failed: Number can't be blank")
            end
          end
        end
      end
    end
  end
end
