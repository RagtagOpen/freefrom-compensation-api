class ResourcesController < ApplicationController
  before_action :find_resource, only: [:show, :update, :destroy]

  def show
    render json: @resource
  end

  def create
    # TODO: authenticate admin user
    @resource = Resource.new(resource_category_id: params[:resource_category_id], state: params[:state])

    begin
      @resource.save!
    rescue ActiveRecord::RecordInvalid => e
      render status: 400, json: { error: e.message } and return
    end
    render status: 201, json: @resource
  end

  def destroy
    # TODO: authenticate admin user
    @resource.destroy
    render status: 204, json: {}
  end

  def update
    # TODO: authenticate admin user
    begin
      attributes = params.permit(upsert_params(Resource))
      @resource.update!(attributes)
    rescue ActiveRecord::RecordInvalid => e
      render status: 400, json: { error: e.message } and return
    end

    render json: @resource
  end

  private

  def find_resource
    begin
      @resource = Resource.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render status: 404, json: {} and return
    end
  end
end