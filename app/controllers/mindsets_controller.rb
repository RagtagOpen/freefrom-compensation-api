# frozen_string_literal: true

class MindsetsController < ApplicationController
  before_action :authenticate_admin, only: %i[create destroy update]
  before_action :find_mindset, only: %i[destroy show update]

  def show
    render json: @mindset
  end

  def index
    render json: Mindset.all.to_a
  end

  def create
    @mindset = Mindset.new(resource_category_id: params[:resource_category_id])

    begin
      @mindset.save!
    rescue ActiveRecord::RecordInvalid => e
      render status: 400, json: { error: e.message } and return
    end
    render status: 201, json: @mindset
  end

  def destroy
    @mindset.destroy
    render status: 204, json: {}
  end

  def update
    begin
      attributes = params.permit(Mindset.update_params)
      @mindset.update!(attributes)
    rescue ActiveRecord::RecordInvalid => e
      render status: 400, json: { error: e.message } and return
    end

    render json: @mindset
  end

  private

  def find_mindset
    @mindset = Mindset.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render status: 404, json: {} and return
  end
end
