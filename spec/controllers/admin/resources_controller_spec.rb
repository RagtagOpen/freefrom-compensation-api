require 'rails_helper'

describe Admin::ResourcesController, type: :controller do
  setup_admin_controller_spec

  let(:id) { 1000 }

  let!(:resource) do
    create(:resource, :with_resource_category, id: id)
  end

  describe '#update' do
    ####################
    # challenges param #
    ####################

    context 'when challenges is empty' do
      let(:params) { { id: id, 'resource': { challenges: '' } } }

      it 'sets challenges to an empty array' do
        put :update, params: params
        resource.reload
        expect(resource.challenges).to eq([])
      end
    end

    context 'when challenges has one element' do
      let(:params) { { id: id, 'resource': { challenges: 'Challenge 1' } } }

      it 'sets challenges to an empty array' do
        put :update, params: params
        resource.reload
        expect(resource.challenges).to eq(['Challenge 1'])
      end
    end

    context 'when challenges has multiple elements' do
      let(:params) { { id: id, 'resource': { challenges: "Challenge 1\r\n\r\n*-*-*-*-*\r\n\r\nChallenge 2" } } }

      it 'sets challenges to an empty array' do
        put :update, params: params
        resource.reload
        expect(resource.challenges).to eq(['Challenge 1', 'Challenge 2'])
      end
    end

    ###################
    # resources param #
    ###################

    context 'when resources is empty' do
      let(:params) { { id: id, 'resource': { resources: '' } } }

      it 'sets resources to an empty array' do
        put :update, params: params
        resource.reload
        expect(resource.resources).to eq([])
      end
    end

    context 'when resources has one element' do
      let(:params) { { id: id, 'resource': { resources: 'Resource 1' } } }

      it 'sets resources to an empty array' do
        put :update, params: params
        resource.reload
        expect(resource.resources).to eq(['Resource 1'])
      end
    end

    context 'when resources has multiple elements' do
      let(:params) { { id: id, 'resource': { resources: "Resource 1\r\n\r\n*-*-*-*-*\r\n\r\nResource 2" } } }

      it 'sets resources to an empty array' do
        put :update, params: params
        resource.reload
        expect(resource.resources).to eq(['Resource 1', 'Resource 2'])
      end
    end

    ##############
    # tips param #
    ##############

    context 'when tips is empty' do
      let(:params) { { id: id, 'resource': { tips: '' } } }

      it 'sets tips to an empty array' do
        put :update, params: params
        resource.reload
        expect(resource.tips).to eq([])
      end
    end

    context 'when tips has one element' do
      let(:params) { { id: id, 'resource': { tips: 'Tip 1' } } }

      it 'sets tips to an empty array' do
        put :update, params: params
        resource.reload
        expect(resource.tips).to eq(['Tip 1'])
      end
    end

    context 'when tips has multiple elements' do
      let(:params) { { id: id, 'resource': { tips: "Tip 1\r\n\r\n*-*-*-*-*\r\n\r\nTip 2" } } }

      it 'sets tips to an empty array' do
        put :update, params: params
        resource.reload
        expect(resource.tips).to eq(['Tip 1', 'Tip 2'])
      end
    end

    ###############
    # steps param #
    ###############

    context 'when steps is empty' do
      let(:params) { { id: id, 'resource': { steps: '' } } }

      it 'sets steps to an empty array' do
        put :update, params: params
        resource.reload
        expect(resource.steps).to eq([])
      end
    end

    context 'when steps has one element' do
      let(:params) { { id: id, 'resource': { steps: 'Step 1' } } }

      it 'sets steps to an empty array' do
        put :update, params: params
        resource.reload
        expect(resource.steps).to eq(['Step 1'])
      end
    end

    context 'when steps has multiple elements' do
      let(:params) { { id: id, 'resource': { steps: "Step 1\r\n\r\n*-*-*-*-*\r\n\r\nStep 2" } } }

      it 'sets steps to an empty array' do
        put :update, params: params
        resource.reload
        expect(resource.steps).to eq(['Step 1', 'Step 2'])
      end
    end

    ############################
    # what_if_i_disagree param #
    ############################

    context 'when steps is empty' do
      let(:params) { { id: id, 'resource': { what_if_i_disagree: '' } } }

      it 'sets what_if_i_disagree to an empty array' do
        put :update, params: params
        resource.reload
        expect(resource.what_if_i_disagree).to eq([])
      end
    end

    context 'when what_if_i_disagree has one element' do
      let(:params) { { id: id, 'resource': { what_if_i_disagree: 'What if I Disagree 1' } } }

      it 'sets what_if_i_disagree to an empty array' do
        put :update, params: params
        resource.reload
        expect(resource.what_if_i_disagree).to eq(['What if I Disagree 1'])
      end
    end

    context 'when what_if_i_disagree has multiple elements' do
      let(:params) { { id: id, 'resource': { what_if_i_disagree: "What if I Disagree 1\r\n\r\n*-*-*-*-*\r\n\r\nWhat if I Disagree 2" } } }

      it 'sets what_if_i_disagree to an empty array' do
        put :update, params: params
        resource.reload
        expect(resource.what_if_i_disagree).to eq(['What if I Disagree 1', 'What if I Disagree 2'])
      end
    end

    ########################
    # what_to_expect param #
    ########################

    context 'when steps is empty' do
      let(:params) { { id: id, 'resource': { what_to_expect: '' } } }

      it 'sets what_to_expect to an empty array' do
        put :update, params: params
        resource.reload
        expect(resource.what_to_expect).to eq([])
      end
    end

    context 'when what_to_expect has one element' do
      let(:params) { { id: id, 'resource': { what_to_expect: 'What to Expect 1' } } }

      it 'sets what_to_expect to an empty array' do
        put :update, params: params
        resource.reload
        expect(resource.what_to_expect).to eq(['What to Expect 1'])
      end
    end

    context 'when what_to_expect has multiple elements' do
      let(:params) { { id: id, 'resource': { what_to_expect: "What to Expect 1\r\n\r\n*-*-*-*-*\r\n\r\nWhat to Expect 2" } } }

      it 'sets what_to_expect to an empty array' do
        put :update, params: params
        resource.reload
        expect(resource.what_to_expect).to eq(['What to Expect 1', 'What to Expect 2'])
      end
    end
  end
end
