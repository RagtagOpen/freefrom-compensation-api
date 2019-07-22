require 'carmen'

class Resource < ApplicationRecord
    include Carmen
    STATE_CODES = Country.named('United States').subregions.map(&:code)

    belongs_to :resource_category

    validates :state, inclusion: { in: STATE_CODES, allow_nil: true, message: "%{value} is not a valid US state code" }
end
