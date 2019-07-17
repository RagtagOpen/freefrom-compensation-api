require "#{Rails.root}/lib/helpers/api_helpers"

describe APIHelpers do
  include described_class

  class self::Book
    def attributes
      # define this method
    end
  end

  describe '#upsert_params' do
    before do
      allow_any_instance_of(self.class::Book)
        .to receive(:attributes)
        .and_return({
          'title' => nil,
          'chapters' => [],
        })
    end

    it 'correctly generates an array of parameter rules' do
      permitted_params = upsert_params(self.class::Book)

      expect(permitted_params).to include(:title)
      expect(permitted_params).to include({ chapters: [] })
    end
  end
end