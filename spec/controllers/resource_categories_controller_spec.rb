require 'rails_helper'
require_relative './shared/unauthenticated_spec'
require_relative './shared/regular_user_spec'

describe ResourceCategoriesController, type: :controller do
  let(:token) { Knock::AuthToken.new(payload: { sub: user.id }).token }
  let(:headers) { { 'Authorization': "Bearer #{token}" } }
  let(:id) { 1000 }

  it_behaves_like 'an unauthenticated object', ResourceCategory
  it_behaves_like 'an object authenticated with a regular user', ResourceCategory

  describe '#create' do
    context 'with admin user' do
      let(:user) { create(:user, :admin) }

      before do
        request.headers.merge! headers
      end

      it 'returns 201 and the resource category' do
        post :create
        expect(response.status).to eq(201)

        body = JSON.parse(response.body)
        expect(body['id']).to be_a(Integer)
      end
    end
  end

  describe '#destroy' do
    before do
      create(:resource_category, id: id)
    end

    context 'with admin user' do
      let(:user) { create(:user, :admin) }

      before do
        request.headers.merge! headers
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
    context 'with admin user' do
      let(:user) { create(:user, :admin) }

      before do
        request.headers.merge! headers
      end

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
              short_description: 'New short description',
              description: 'New description',
              icon: "\x05\x00\x68\x65\x6c\x6c\x6f",
              seo_title: 'New SEO title',
              seo_description: 'New SEO description',
              seo_keywords: ['keyword1', 'keyword2', 'keyword3'],
              share_image: "\x05\x00\x68\x65\x6c\x6c\x6f",
            }
          end

          it 'returns 200 and new resource category' do
            put :update, params: params.merge({ id: id })
            expect(response.status).to eq(200)

            body = JSON.parse(response.body)
            keys = %w(description name seo_description seo_keywords seo_title short_description)

            keys.each do |key|
              expect(body[key]).to eq(params[key.to_sym])
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
              put :update, params: params.merge({ id: id })
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
