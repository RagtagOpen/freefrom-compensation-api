# frozen_string_literal: true

class ResourceLink < ApplicationRecord
  include Updateable

  belongs_to :resource
end
