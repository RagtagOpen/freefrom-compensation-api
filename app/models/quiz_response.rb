# frozen_string_literal: true

class QuizResponse < ApplicationRecord
  include Updateable

  belongs_to :quiz_question
  has_and_belongs_to_many :mindsets, inverse_of: nil

  def self.update_params
    params = super
    params << { mindset_ids: [] }
  end
end
