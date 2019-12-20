# frozen_string_literal: true

class ResourcesController < ApplicationController
  before_action :find_resource, only: %i[destroy links show steps update]
  before_action :require_state, only: %i[create search]

  def show
    render json: @resource
  end

  def create
    @resource = Resource.new(resource_category_id: params[:resource_category_id], state: params[:state])

    begin
      @resource.save!
    rescue ActiveRecord::RecordInvalid => e
      render status: 400, json: { error: e.message } and return
    end
    render status: 201, json: @resource
  end

  def destroy
    @resource.destroy
    render status: 204, json: {}
  end

  def update
    begin
      attributes = params.permit(Resource.update_params)
      @resource.update!(attributes)
    rescue ActiveRecord::RecordInvalid => e
      render status: 400, json: { error: e.message } and return
    end

    render json: @resource
  end

  def search
    begin
      mindset = Mindset.find(params[:mindset_id])

      @resource = Resource.find_by!(
        resource_category_id: mindset.resource_category_id,
        state: params[:state]
      )
    rescue ActiveRecord::RecordNotFound
      render status: 404, json: {} and return
    end

    render status: 200, json: @resource
  end

  def search_by_category
    begin
      resource_category = ResourceCategory.find_by(slug: params[:slug])

      @resource = Resource.find_by!(
        resource_category_id: resource_category.id,
        state: params[:state]
      )
    rescue ActiveRecord::RecordNotFound
      render status: 404, json: {} and return
    end

    render status: 200, json: @resource
  end

  private

  def require_state
    render status: 400, json: { error: 'Missing state parameter' } and return unless params[:state].present?
  end

  def find_resource
    @resource = Resource.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render status: 404, json: {} and return
  end
end
