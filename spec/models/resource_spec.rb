require 'rails_helper'

RSpec.describe Resource, type: :model do
  describe '#valid?' do
    context 'when state code is invalid' do
      it 'returns false' do
        resource = build(:resource, state: 'XO')
        expect(resource.valid?).to be false
      end
    end
    
    context 'when state code is valid' do
      it 'returns true' do
        resource = build(:resource, state: 'NY')
        expect(resource.valid?).to be true
      end
    end

    context 'when state code is nil' do
      it 'returns true' do
        resource = build(:resource)
        expect(resource.valid?).to be true
      end
    end
  end
end
