class ResourceCategoriesController < ApplicationController
  before_action :find_resource_category, only: [:show, :update, :destroy]

  def show
    render json: @resource_category
  end

  def create
    # TODO: authenticate admin user
    @resource_category = ResourceCategory.create
    render status: 201, json: @resource_category
  end

  def destroy
    # TODO: authenticate admin user
    @resource_category.destroy
    render status: 204, json: {}
  end

  def update
    # TODO: authenticate admin user
    # TODO: refactor this code
    valid_attrs = []
    ResourceCategory.new.attributes.each do |key, value|
      valid_attrs << key.to_sym if value.nil?
      valid_attrs << { key.to_sym => [] } if value == []
    end

    attributes = params.permit(valid_attrs)
    @resource_category.update!(attributes)

    render json: @resource_category
  end

  private

  def find_resource_category
    begin
      @resource_category = ResourceCategory.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render status: 404, json: {} and return
    end
  end
end
