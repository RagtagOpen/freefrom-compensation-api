class ResourceCategoriesController < ApplicationController
  before_action :find_resource_category, only: [:show, :update, :destroy]
  before_action :authenticate_admin, only: [:create, :destroy, :update]

  def show
    render json: @resource_category
  end

  def create
    @resource_category = ResourceCategory.create
    render status: 201, json: @resource_category
  end

  def destroy
    @resource_category.destroy
    render status: 204, json: {}
  end

  def update
    attributes = params.permit(upsert_params(ResourceCategory))
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
