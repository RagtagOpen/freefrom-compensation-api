require 'rails_helper'
require_relative './shared/unauthenticated_spec'
require_relative './shared/regular_user_spec'

describe ResourcesController, type: :controller do
  it_behaves_like 'an unauthenticated object', Resource, create: { resource_category_id: 123 }
  it_behaves_like 'an object authenticated with a regular user', create: { resource_category_id: 123 }

  context 'with admin user' do
    setup_admin_controller_spec

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
          expect(body['error']).to eq('Validation failed: Resource category must exist')
        end
      end

      context 'without state' do
        let(:state) { nil }

        it 'returns 400 and an error' do
          post :create, params: params
          expect(response.status).to eq(400)

          body = JSON.parse(response.body)
          expect(body['error']).to eq('Missing state parameter')
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
      before do
        create(:resource, :with_resource_category, id: id)
      end

      it 'returns 204 and an empty body' do
        delete :destroy, params: { id: id }
        expect(response.status).to eq(204)

        body = JSON.parse(response.body)
        expect(body).to be_empty
      end
    end

    describe '#update' do
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
              state: 'WV',
              who: 'You are eligible to apply if you were injured as the result of a crime.You are also eligible to apply if you are the legal dependent of someonewho was killed as the result of a crime',
              when: 'The application must be received within 2 years after the date ofthe crime',
              time: 'On average, it takes 7.5 months for an application to be approvedor denied',
              cost: 'It is free to apply',
              award: 'If you were injured, the maximum you can receive for your expenses is $35,000.',
              covered_expenses: 'You can get reimbursed for the following expenses: Medical / dental expenses; funeral and burial expenses; mental healthcounseling; lost wages / income; lost support of eligible dependents; andmileage to medical treatment facilities.',
              likelihood: 'Your chances of getting reimbursement depend on your meeting all of the application’s criteria. See “How-to File” below for moreinformation.',
              safety: 'This application is made directly to the state. You will not need toconfront your harm-doer to apply.',
              story: 'You will have to include information about what happened to you inyour application',
              tips: [
                ' If you are close to the 2 year deadline but don’t have certain documents (police report, invoices, receipts) do not wait to submit yourapplication.   Instead,   submit   the   application   and   follow-up   with   thedocuments when you get them.'
              ],
              resource_category_id: new_resource_category.id.to_i
            }
          end

          it 'returns 200 and new resource' do
            put :update, params: params.merge(id: id)
            expect(response.status).to eq(200)

            body = JSON.parse(response.body)
            keys = %w[state time cost award likelihood safety story resource_category_id]

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
              put :update, params: params.merge(id: id)
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
              put :update, params: params.merge(id: id)
              expect(response.status).to eq(400)

              body = JSON.parse(response.body)
              expect(body['error']).to eq("Validation failed: State #{new_state} is not a valid US state code")
            end
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

  describe '#steps' do
    context 'where resource doesn\'t exist' do
      it 'returns 404' do
        get :steps, params: { id: 'fake-id' }
        expect(response.status).to eq(404)

        body = JSON.parse(response.body)
        expect(body).to be_empty
      end
    end

    context 'where resource has no resource steps' do
      let!(:resource) { create(:resource, :with_resource_category) }
      it 'returns 200 and an empty array' do
        get :steps, params: { id: resource.id.to_s }
        expect(response.status).to eq(200)

        body = JSON.parse(response.body)
        expect(body).to be_a(Array)
        expect(body).to be_empty
      end
    end

    context 'where resource has steps' do
      let!(:resource) { create(:resource, :with_resource_category) }
      let!(:resource_step_one) { create(:resource_step, number: 5, resource_id: resource.id) }
      let!(:resource_step_two) { create(:resource_step, number: 6, resource_id: resource.id) }

      it 'returns 200 and an empty array' do
        get :steps, params: { id: resource.id.to_s }
        expect(response.status).to eq(200)

        body = JSON.parse(response.body)
        ids = body.map { |step| step['id'] }
        numbers = body.map { |step| step['number'] }

        expect(ids).to include(resource_step_one.id.to_i)
        expect(ids).to include(resource_step_two.id.to_i)
        expect(numbers).to include(5)
        expect(numbers).to include(6)
      end
    end
  end
end
