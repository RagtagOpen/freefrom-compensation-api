# frozen_string_literal: true

class ResourceStep < ApplicationRecord
  include Updateable

  belongs_to :resource
  validates :number, uniqueness: { scope: :resource_id, message: 'should be unique within each resource' }, presence: true
end
