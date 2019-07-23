require 'rails_helper'
require 'spec_helper'

describe ResourceStepsController, type: :controller do
  describe '#show' do
    let(:id) { 1000 }

    context 'where resource step exists' do
      before do
        resource_step = create(:resource_step, :with_resource, id: id)
      end

      it 'returns 200 and the resource' do
        get :show, params: { id: id }
        expect(response.status).to eq(200)

        body = JSON.parse(response.body)
        expect(body['id']).to eq(id)
      end
    end

    context 'where the resource step doesn\'t exist' do
      it 'returns 404' do
        get :show, params: { id: id }
        expect(response.status).to eq(404)
      end
    end
  end

  describe '#create' do
    let!(:resource_category) { create(:resource_category) }
    let(:resource_category_id) { resource_category.id.to_i }
    let(:state) { 'NY' }

    let(:params) { { resource_category_id: resource_category_id, state: state } }

    context 'an invalid resource category id' do
      let(:resource_category_id) { 'fake-id' }

      it 'returns 400 and an error' do
        post :create, params: params
        expect(response.status).to eq(400)
        
        body = JSON.parse(response.body)
        expect(body['error']).to eq("Validation failed: Resource category must exist")
      end
    end

    context 'without state' do
      let(:state) { nil }

      it 'returns 400 and an error' do
        post :create, params: params
        expect(response.status).to eq(400)
        
        body = JSON.parse(response.body)
        expect(body['error']).to eq("Missing state parameter")
      end
    end

    it 'returns 201 and the resource' do
      post :create, params: params
      expect(response.status).to eq(201)

      body = JSON.parse(response.body)
      expect(body['id']).to be_a(Integer)
    end
  end

  describe '#destroy' do
    let(:id) { 1000 }

    before do
      resource = create(:resource, :with_resource_category, id: id)
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

    context 'where resource doesn\'t exist' do
      it 'returns 404 and an empty body' do
        put :update, params: { id: id }
        expect(response.status).to eq(404)

        body = JSON.parse(response.body)
        expect(body).to be_empty
      end
    end

    context 'where resource does exist' do
      let!(:resource) { create(:resource, :with_resource_category, id: id) }
      let!(:new_resource_category) { create(:resource_category) }

      context 'and update succeeds' do
        let(:params) do
          {
            state: 'NY',
            time: 'Months. Note: Depending on the case, it could take longer.',
            cost: 'It is free of charge.',
            award: 'You can potentially claim full amount of reasonable losses in awards for shattered computer, ER visits, or lost days from work.',
            likelihood: 'The likelihood to get reimbursement through this option depends on whether a criminal case is brought. The system takes care of everything but that only happens if the evidence is strong enough for a prosecutor to bring charges.',
            safety: 'It is likely that the prosecutor will call you to testify in the criminal case with your abuser present.',
            story: 'You will have to share your story when you make a report to law enforcement and if you are called to testify, you will have to do so on the stand at trial.',
            resource_category_id: new_resource_category.id.to_i,
          }
        end

        it 'returns 200 and new resource' do
          put :update, params: params.merge({ id: id })
          expect(response.status).to eq(200)

          body = JSON.parse(response.body)
          keys = %w(state time cost award likelihood safety story resource_category_id)

          keys.each do |key|
            expect(body[key]).to eq(params[key.to_sym])
          end
        end

        context 'only altering one field' do
          let(:new_state) { 'ME' }
          let(:old_time) { 'Months. Note: Depending on the case, it could take longer.' }
          let(:params) { { state: new_state } }

          before do
            resource.time = old_time
            resource.save!
          end

          it 'updates the fields passed into the params and does not modify anything else' do
            put :update, params: params.merge({ id: id })
            expect(response.status).to eq(200)

            body = JSON.parse(response.body)
            expect(body['state']).to eq(new_state)
            expect(body['time']).to eq(old_time)
          end
        end

        context 'with an invalid field' do
          let(:new_state) { 'XO' }
          let(:params) { { state: new_state } }

          it 'returns 400 and an error message' do
            put :update, params: params.merge({ id: id })
            expect(response.status).to eq(400)
            
            body = JSON.parse(response.body)
            expect(body['error']).to eq("Validation failed: State #{new_state} is not a valid US state code")
          end
        end
      end
    end
  end

  describe '#search' do
    let!(:resource_category) { create(:resource_category) }
    let!(:resource) { create(:resource, state: 'NY', resource_category_id: resource_category.id) }

    let(:state) { 'NY' }
    let(:resource_category_id) { resource_category.id.to_i }

    let(:params) { { resource_category_id: resource_category_id, state: state } }

    context 'without state param' do
      let(:state) { nil }

      it 'returns 400' do
        get :search, params: params
        expect(response.status).to eq(400)
        
        body = JSON.parse(response.body)
        expect(body['error']).to eq('Missing state parameter')
      end
    end

    context 'where resource exists for category but not state' do
      let(:state) { 'ME' }

      it 'returns 404' do
        get :search, params: params
        expect(response.status).to eq(404)
        
        body = JSON.parse(response.body)
        expect(body).to be_empty
      end
    end

    context 'where resource exists for state but not category' do
      let(:resource_category_id) { 'fake-id' }

      it 'returns 404' do
        get :search, params: params
        expect(response.status).to eq(404)
        
        body = JSON.parse(response.body)
        expect(body).to be_empty
      end
    end

    context 'where resource exists for state and category' do
      it 'returns 200' do
        get :search, params: params
        expect(response.status).to eq(200)
        
        body = JSON.parse(response.body)
        expect(body['id']).to eq(resource.id.to_i)
        expect(body['resource_category_id']).to eq(resource_category_id)
        expect(body['state']).to eq(state)
      end
    end
  end
end
