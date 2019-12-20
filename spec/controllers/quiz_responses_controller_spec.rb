require 'rails_helper'
require_relative './shared/unauthenticated_spec'

describe QuizResponsesController, type: :controller do
  it_behaves_like 'an unauthenticated object', QuizResponse, create: { quiz_question_id: 123 }

  context 'with admin user' do
    setup_admin_controller_spec

    describe '#create' do
      let!(:quiz_question) { create(:quiz_question) }
      let(:quiz_question_id) { quiz_question.id.to_i }

      let(:params) { { quiz_question_id: quiz_question_id } }

      context 'an invalid quiz question id' do
        let(:quiz_question_id) { 'fake-id' }

        it 'returns 400 and an error' do
          post :create, params: params
          expect(response.status).to eq(400)

          body = JSON.parse(response.body)
          expect(body['error']).to eq('Quiz question must exist')
        end
      end

      it 'returns 201 and the quiz response' do
        post :create, params: params
        expect(response.status).to eq(201)

        body = JSON.parse(response.body)
        expect(body['id']).to be_a(Integer)
      end
    end

    describe '#destroy' do
      context 'where the quiz response exists' do
        before do
          create(:quiz_response, :with_quiz_question, id: id)
        end

        it 'returns 204 and an empty body' do
          delete :destroy, params: { id: id }
          expect(response.status).to eq(204)

          body = JSON.parse(response.body)
          expect(body).to be_empty
        end
      end

      context 'where the quiz response does not exist' do
        it 'returns 404 and an empty body' do
          delete :destroy, params: { id: id }
          expect(response.status).to eq(404)
        end
      end
    end

    describe '#update' do
      context 'where quiz response doesn\'t exist' do
        it 'returns 404 and an empty body' do
          put :update, params: { id: id }
          expect(response.status).to eq(404)

          body = JSON.parse(response.body)
          expect(body).to be_empty
        end
      end

      context 'where quiz response does exist' do
        let!(:quiz_response) { create(:quiz_response, :with_quiz_question, id: id) }
        let!(:new_quiz_question) { create(:quiz_question) }
        let!(:new_mindset) { create(:mindset, :with_resource_category) }

        context 'and update succeeds' do
          let(:params) do
            {
              text: 'I don’t have a lot of time to spare to try and get compensation (up to 8 hours).',
              quiz_question_id: new_quiz_question.id,
              mindset_ids: [new_mindset.id]
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

          context 'with an invalid mindset' do
            let(:params) { { mindset_ids: [1] } }

            it 'returns 400 and an error message' do
              put :update, params: params.merge(id: id)
              expect(response.status).to eq(400)

              body = JSON.parse(response.body)
              expect(body['error']).to eq("Couldn't find Mindset with 'id'=[1]")
            end
          end
        end
      end
    end
  end
end
