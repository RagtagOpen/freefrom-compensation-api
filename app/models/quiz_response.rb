# frozen_string_literal: true

class QuizResponse < ApplicationRecord
  belongs_to :quiz_question
  has_and_belongs_to_many :mindsets, inverse_of: nil
end
