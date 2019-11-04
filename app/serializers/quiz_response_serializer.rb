# frozen_string_literal: true

class QuizResponseSerializer < ActiveModel::Serializer
  attributes :id, :text, :quiz_question_id, :mindset_ids, :created_at, :updated_at
end
