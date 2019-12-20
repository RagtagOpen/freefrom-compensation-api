# frozen_string_literal: true

class QuizQuestionsController < ApplicationController
  before_action :find_quiz_question, only: %i[destroy links responses show steps update]

  def show
    render json: @quiz_question
  end

  def create
    render status: 201, json: QuizQuestion.create
  end

  def destroy
    @quiz_question.destroy
    render status: 204, json: {}
  end

  def update
    attributes = params.permit(QuizQuestion.update_params)
    @quiz_question.update!(attributes)

    render json: @quiz_question
  end

  def index
    render json: QuizQuestion.all.to_a
  end

  def responses
    render json: @quiz_question.quiz_responses
  end

  private

  def find_quiz_question
    @quiz_question = QuizQuestion.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render status: 404, json: {} and return
  end
end
