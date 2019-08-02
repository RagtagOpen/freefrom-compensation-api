class ResourceStepsController < ApplicationController
  before_action :authenticate_admin, only: [:create, :update, :destroy]
  before_action :find_resource_step, only: [:show, :update, :destroy]

  def show
    render json: @resource_step    
  end

  def create
    render status: 400, json: { error: 'Missing number parameter' } and return unless params[:number].present?
    @resource_step = ResourceStep.new(resource_id: params[:resource_id], number: params[:number])

    begin
      @resource_step.save!
    rescue ActiveRecord::RecordInvalid => e
      render status: 400, json: { error: e.message } and return
    end
    render status: 201, json: @resource_step
  end

  def destroy
    @resource_step.destroy
    render status: 204, json: {}
  end

  def update
    begin
      attributes = params.permit(upsert_params(ResourceStep))
      @resource_step.update!(attributes)
    rescue ActiveRecord::RecordInvalid => e
      render status: 400, json: { error: e.message } and return
    end

    render json: @resource_step
  end

  private

  def find_resource_step
    begin
      @resource_step = ResourceStep.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render status: 404, json: {} and return
    end
  end
end