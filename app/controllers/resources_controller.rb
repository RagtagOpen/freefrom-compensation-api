class ResourcesController < ApplicationController
  before_action :find_resource, only: [:show, :update, :destroy, :steps]
  before_action :require_state, only: [:create, :search]

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

  def search
    begin
      @resource = Resource.find_by!(
        resource_category_id: params[:resource_category_id],
        state: params[:state]
      )
    rescue ActiveRecord::RecordNotFound
      render status: 404, json: {} and return
    end

    render status: 200, json: @resource
  end

  def steps
    render json: @resource.resource_steps
  end

  private

  def require_state
    render status: 400, json: { error: "Missing state parameter"} and return unless params[:state].present?
  end

  def find_resource
    begin
      @resource = Resource.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render status: 404, json: {} and return
    end
  end
end