require 'rails_helper'
require_relative './shared/unauthenticated_spec'

describe QuizQuestionsController, type: :controller do
  it_behaves_like 'an unauthenticated object', QuizQuestion

  describe '#index' do
    context 'where quiz questions exist' do
      let!(:quiz_question1) { create(:quiz_question) }
      let!(:quiz_question2) { create(:quiz_question) }

      it 'returns all mindsets' do
        get :index
        expect(response.status).to eq(200)

        body = JSON.parse(response.body)
        ids = body.map { |quiz_question| quiz_question['id'] }

        [quiz_question1, quiz_question2].map(&:id).each do |id|
          expect(ids).to include(id)
        end
      end
    end

    context 'where no quiz questions exist' do
      it 'returns an empty array' do
        get :index
        expect(response.status).to eq(200)

        body = JSON.parse(response.body)
        expect(body).to be_a(Array)
        expect(body).to be_empty
      end
    end
  end

  describe '#responses' do
    context 'where quiz question doesn\'t exist' do
      it 'returns 404' do
        get :responses, params: { id: 123 }
        expect(response.status).to eq(404)
      end
    end

    context 'where quiz question exists' do
      let!(:quiz_question) { create(:quiz_question) }
      let(:params) { { id: quiz_question.id } }

      context 'and it has no responses' do
        it 'returns 200 and an empty array' do
          get :responses, params: params
          expect(response.status).to eq(200)

          body = JSON.parse(response.body)
          expect(body).to be_a(Array)
          expect(body).to be_empty
        end
      end

      context 'and it has responses' do
        let!(:mindset) { create(:mindset, :with_resource_category) }
        let!(:response1) do
          create(:quiz_response, quiz_question_id: quiz_question.id, mindset_ids: [mindset.id])
        end
        let!(:response2) { create(:quiz_response, quiz_question_id: quiz_question.id) }

        it 'returns 200 and an array of responses' do
          get :responses, params: params
          expect(response.status).to eq(200)

          body = JSON.parse(response.body)
          expect(body.length).to eq(2)

          ids = body.map { |response| response['id'] }
          [response1, response2].map(&:id).each do |id|
            expect(ids).to include(id)
          end

          expect(body.first['mindset_ids']).to eq([mindset.id])
        end
      end
    end
  end

  context 'with admin user' do
    setup_admin_controller_spec

    describe '#create' do
      it 'returns 201 and the quiz question' do
        post :create
        expect(response.status).to eq(201)

        body = JSON.parse(response.body)
        expect(body['id']).to be_a(Integer)
      end
    end

    describe '#destroy' do
      context 'where quiz question exists' do
        before do
          create(:quiz_question, id: id)
        end

        it 'returns 204 and an empty body' do
          delete :destroy, params: { id: id }
          expect(response.status).to eq(204)

          body = JSON.parse(response.body)
          expect(body).to be_empty
        end
      end

      context 'where quiz question doesn\'t exist' do
        it 'returns 404' do
          delete :destroy, params: { id: id }
          expect(response.status).to eq(404)
        end
      end
    end

    describe '#update' do
      context 'where quiz question doesn\'t exist' do
        it 'returns 404 and an empty body' do
          put :update, params: { id: id }
          expect(response.status).to eq(404)

          body = JSON.parse(response.body)
          expect(body).to be_empty
        end
      end

      context 'where quiz_question does exist' do
        let!(:quiz_question) { create(:quiz_question, id: id) }

        context 'and update succeeds' do
          let(:params) do
            {
              title: 'Your time',
              description: 'Some types of compensation are more time-consuming than others. Think about how much time you have to spend trying to get compensation and pick the statement below that best describes you.'
            }
          end

          it 'returns 200 and new resource category' do
            put :update, params: params.merge(id: id)
            expect(response.status).to eq(200)

            body = JSON.parse(response.body)

            params.each do |key, value|
              expect(body[key.to_s]).to eq(value)
            end
          end

          context 'only altering one field' do
            let(:new_title) { 'New title' }
            let(:old_description) { 'Here\'s a description I want to keep' }
            let(:params) { { title: new_title } }

            before do
              quiz_question.description = old_description
              quiz_question.save!
            end

            it 'updates the fields passed into the params and does not modify anything else' do
              put :update, params: params.merge(id: id)
              expect(response.status).to eq(200)

              body = JSON.parse(response.body)
              expect(body['title']).to eq(new_title)
              expect(body['description']).to eq(old_description)
            end
          end
        end
      end
    end
  end
end
