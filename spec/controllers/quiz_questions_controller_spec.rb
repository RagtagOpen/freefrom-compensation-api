require 'rails_helper'
require_relative './shared/unauthenticated_spec'
require_relative './shared/regular_user_spec'

describe QuizQuestionsController, type: :controller do
  it_behaves_like 'an unauthenticated object', QuizQuestion
  it_behaves_like 'an object authenticated with a regular user'

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
