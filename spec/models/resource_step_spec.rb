require 'rails_helper'

RSpec.describe ResourceStep, type: :model do
  describe '#valid?' do
    context 'number is not unique within resource' do
      let!(:resource) { create(:resource, :with_resource_category) }
      let!(:first_resource_step) { create(:resource_step, resource_id: resource.id, number: 1) }

      it 'returns false' do
        resource_step = build(:resource_step, resource_id: resource.id, number: 1)
        expect(resource_step).not_to be_valid
      end
    end

    context 'number is unique within resource' do
      let!(:resource) { create(:resource, :with_resource_category) }

      it 'returns true' do
        resource_step = build(:resource_step, resource_id: resource.id, number: 1)
        expect(resource_step).to be_valid
      end
    end

    context 'number is nil' do
      it 'returns false' do
        resource_step = build(:resource_step, :with_resource, number: nil)
        expect(resource_step).not_to be_valid
      end
    end
  end
end
