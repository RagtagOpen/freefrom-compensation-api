# frozen_string_literal: true

class QuizResponsesController < ApplicationController
  before_action :authenticate_admin, only: %i[create destroy update]
  before_action :find_quiz_response, only: %i[destroy links show steps update]

  def show
    render json: @quiz_response
  end

  def create
    @quiz_response = QuizResponse.new(quiz_question_id: params[:quiz_question_id])

    if @quiz_response.save
      render status: 201, json: @quiz_response
    else
      render status: 400, json: { error: @quiz_response.errors.full_messages.first } and return
    end
  end

  def destroy
    @quiz_response.destroy
    render status: 204, json: {}
  end

  def update
    begin
      attributes = params.permit(QuizResponse.update_params)
      @quiz_response.update!(attributes)
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound => e
      render status: 400, json: { error: e.message } and return
    end

    render json: @quiz_response
  end

  private

  def find_quiz_response
    @quiz_response = QuizResponse.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render status: 404, json: {}
  end
end
