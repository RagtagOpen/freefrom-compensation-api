require 'rails_helper'
require_relative './shared/unauthenticated_spec'
require_relative './shared/regular_user_spec'

describe MindsetsController, type: :controller do
  it_behaves_like 'an unauthenticated object', Mindset, create: { resource_category_id: 123 }
  it_behaves_like 'an object authenticated with a regular user', create: { resource_category_id: 123 }

  describe '#index' do
    context 'where mindsets exist' do
      let!(:mindset1) { create(:mindset, :with_resource_category) }
      let!(:mindset2) { create(:mindset, :with_resource_category) }

      it 'returns all mindsets' do
        get :index
        expect(response.status).to eq(200)

        body = JSON.parse(response.body)
        ids = body.map { |mindset| mindset['id'] }

        [mindset1, mindset2].map(&:id).each do |id|
          expect(ids).to include(id)
        end
      end
    end

    context 'where no mindsets exist' do
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
      let!(:resource_category) { create(:resource_category) }
      let(:resource_category_id) { resource_category.id.to_i }

      let(:params) { { resource_category_id: resource_category_id } }

      context 'an invalid resource category id' do
        let(:resource_category_id) { 'fake-id' }

        it 'returns 400 and an error' do
          post :create, params: params
          expect(response.status).to eq(400)

          body = JSON.parse(response.body)
          expect(body['error']).to eq('Validation failed: Resource category must exist')
        end
      end

      it 'returns 201 and the mindset' do
        post :create, params: params
        expect(response.status).to eq(201)

        body = JSON.parse(response.body)
        expect(body['id']).to be_a(Integer)
        expect(body['resource_category_id']).to eq(resource_category_id)
      end
    end

    describe '#destroy' do
      context 'where mindset doesn\'t exist' do
        it 'returns 404' do
          delete :destroy, params: { id: id }
          expect(response.status).to eq(404)
        end
      end

      context 'where minset exists' do
        before do
          create(:mindset, :with_resource_category, id: id)
        end

        it 'returns 204 and an empty body' do
          delete :destroy, params: { id: id }
          expect(response.status).to eq(204)

          body = JSON.parse(response.body)
          expect(body).to be_empty
        end
      end
    end

    describe '#update' do
      context 'where mindset doesn\'t exist' do
        it 'returns 404 and an empty body' do
          put :update, params: { id: id }
          expect(response.status).to eq(404)

          body = JSON.parse(response.body)
          expect(body).to be_empty
        end
      end

      context 'where mindset does exist' do
        let!(:mindset) { create(:mindset, :with_resource_category, id: id) }
        let!(:new_resource_category) { create(:resource_category) }

        context 'and update succeeds' do
          let(:params) do
            {
              name: 'The Reimbursement Boss',
              description: 'The Reimbursement Boss wants justice from their harm-doer, but also values their time and wants to move forward as quickly as possible. They feel confident telling their story and advocating for themselves in front of others. The name doesn’t lie, this person is an all-around Boss!',
              slug: 'the_reimbursement_boss',
              resource_category_id: new_resource_category.id.to_i
            }
          end

          it 'returns 200 and new mindset' do
            put :update, params: params.merge(id: id)
            expect(response.status).to eq(200)

            body = JSON.parse(response.body)

            params.each do |key, value|
              expect(body[key.to_s]).to eq(value)
            end
          end

          context 'only altering one field' do
            let(:new_description) { 'New mindset description' }
            let(:old_name) { 'The Reimbursement Boss' }
            let(:params) { { description: new_description } }

            before do
              mindset.name = old_name
              mindset.save!
            end

            it 'updates the fields passed into the params and does not modify anything else' do
              put :update, params: params.merge(id: id)
              expect(response.status).to eq(200)

              body = JSON.parse(response.body)
              expect(body['description']).to eq(new_description)
              expect(body['name']).to eq(old_name)
            end
          end
        end
      end
    end
  end
end
