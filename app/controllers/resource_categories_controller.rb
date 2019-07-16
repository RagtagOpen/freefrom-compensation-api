class ResourceCategoriesController < ApplicationController
  before_action :find_resource_category, only: [:show, :update, :destroy]

  def show
    render json: @resource_category
  end

  def create
    # TODO: authenticate admin user
    @resource_category = ResourceCategory.new
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
    # valid_params = ResourceCategory
    #                 .new
    #                 .attributes
    #                 .symbolize_keys
    #                 .except(:id, :created_at, :updated_at)
    #                 .keys
    #                 .merge(:seo_keywords => [])

    attributes = params.permit(:name, :short_description, :description, :icon, :seo_title, :seo_description, :share_image, :seo_keywords => [])
    @resource_category.update!(attributes)
    byebug

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
