require 'rails_helper'
require "#{Rails.root}/app/models/concerns/updateable"

describe Updateable do
  describe '#update_params' do
    it 'correctly generates an array of parameter rules' do
      permitted_params = Resource.update_params

      expect(permitted_params).to include(:time)
      expect(permitted_params).to include(tips: [])
    end

    it 'correctly generates for has and belongs to many relationships' do
      permitted_params = QuizResponse.update_params
      expect(permitted_params).to include(mindset_ids: [])
    end
  end
end
