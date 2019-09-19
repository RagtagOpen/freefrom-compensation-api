# frozen_string_literal: true

class Mindset < ApplicationRecord
  include Updateable

  belongs_to :resource_category
end
