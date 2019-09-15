# frozen_string_literal: true

class QuizQuestion < ApplicationRecord
  has_many :quiz_responses
end
