# frozen_string_literal: true

class QuizQuestion < ApplicationRecord
  include Updateable

  has_many :quiz_responses
end
