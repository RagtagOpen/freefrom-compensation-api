# frozen_string_literal: true

class QuizQuestionsController < ApplicationController
  before_action :authenticate_admin, only: %i[create destroy update]
  before_action :find_quiz_question, only: %i[destroy links show steps update]

  def create
    render status: 201, json: QuizQuestion.create
  end

  def destroy
    @quiz_question.destroy
    render status: 204, json: {}
  end

  def update
    attributes = params.permit(upsert_params(QuizQuestion))
    @quiz_question.update!(attributes)

    render json: @quiz_question
  end

  private

  def find_quiz_question
    @quiz_question = QuizQuestion.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render status: 404, json: {} and return
  end

end
