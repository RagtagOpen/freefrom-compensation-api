class ResourcesController < ApplicationController
  before_action :find_resource, only: [:show, :update, :destroy]

  def show
    render json: @resource
  end

  def create
    # TODO: authenticate admin user
    @resource = Resource.create
    render status: 201, json: @resource
  end

  def destroy
    # TODO: authenticate admin user
    @resource.destroy
    render status: 204, json: {}
  end

  def update
    # TODO: authenticate admin user
    attributes = params.permit(upsert_params(Resource))
    @resource.update!(attributes)

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