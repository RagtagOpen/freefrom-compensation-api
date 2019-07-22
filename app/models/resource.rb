require 'carmen'

class Resource < ApplicationRecord
    include Carmen

    STATE_CODES = Country.named('United States').subregions.map(&:code)
    # belongs_to :resource_category

    validates :state, inclusion: { in: STATE_CODES, message: "%{value} is not a valid US state code" }
end
