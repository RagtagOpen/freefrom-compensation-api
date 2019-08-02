require 'rails_helper'

RSpec.describe Resource, type: :model do
  describe '#valid?' do
    context 'when state code is invalid' do
      it 'returns false' do
        resource = build(:resource, :with_resource_category, state: 'XO')
        expect(resource).not_to be_valid
      end
    end

    context 'when state code is valid' do
      it 'returns true' do
        resource = build(:resource, :with_resource_category, state: 'NY')
        expect(resource).to be_valid
      end
    end

    context 'with no resource category' do
      it 'returns false' do
        resource = build(:resource)
        expect(resource).not_to be_valid
      end
    end

    context 'not unique on state/resource_category_id' do
      let!(:resource_category) { create(:resource_category) }

      before do
        create(:resource, resource_category_id: resource_category.id, state: 'NY')
      end

      it 'returns false' do
        resource = build(:resource, resource_category_id: resource_category.id, state: 'NY')
        expect(resource).not_to be_valid
      end
    end
  end
end
