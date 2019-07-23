require 'carmen'

class Resource < ApplicationRecord
    include Carmen
    STATE_CODES = Country.named('United States').subregions.map(&:code)

    belongs_to  :resource_category
    has_many    :resource_steps

    validates :state, inclusion: { in: STATE_CODES, message: "%{value} is not a valid US state code" }
    validates :state, uniqueness: { scope: :resource_category_id, message: "should be unique within each resource category" }
end
