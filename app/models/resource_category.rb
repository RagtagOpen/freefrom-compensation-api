# frozen_string_literal: true

class ResourceCategory < ApplicationRecord
  include Updateable

  has_one :mindset
end
