require 'rails_helper'
require 'spec_helper'

describe ResourcesController, type: :controller do
  describe '#show' do
    let(:id) { 1000 }

    context 'where resource exists' do
      before do
        resource = build(:resource, id: id)
        resource.save!
      end

      it 'returns 200 and the resource' do
        get :show, params: { id: id }
        expect(response.status).to eq(200)

        body = JSON.parse(response.body)
        expect(body['id']).to eq(id)
      end
    end

    context 'where the resource doesn\'t exist' do
      it 'returns 404' do
        get :show, params: { id: id }
        expect(response.status).to eq(404)
      end
    end
  end

  describe '#create' do
    it 'returns 201 and the resource' do
      post :create
      expect(response.status).to eq(201)

      body = JSON.parse(response.body)
      expect(body['id']).to be_a(Integer)
    end
  end

  describe '#destroy' do
    let(:id) { 1000 }

    before do
      resource = build(:resource, id: id)
      resource.save!
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
      let(:resource) { build(:resource, id: id) }

      before do
        resource.save!
      end

      context 'and update succeeds' do
        let(:params) do
          {
            state: 'NY',
            time: 'Months. Note: Depending on the case, it could take longer.',
            cost: 'It is free of charge.',
            award: 'You can potentially claim full amount of reasonable losses in awards for shattered computer, ER visits, or lost days from work.',
            likelihood: 'The likelihood to get reimbursement through this option depends on whether a criminal case is brought. The system takes care of everything but that only happens if the evidence is strong enough for a prosecutor to bring charges.',
            safety: 'It is likely that the prosecutor will call you to testify in the criminal case with your abuser present.',
            story: 'You will have to share your story when you make a report to law enforcement and if you are called to testify, you will have to do so on the stand at trial.'
          }
        end

        it 'returns 200 and new resource' do
          put :update, params: params.merge({ id: id })
          expect(response.status).to eq(200)

          body = JSON.parse(response.body)
          keys = %w(description name seo_description seo_keywords seo_title short_description)

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
      end
    end
  end
end
