class ResourceCategoriesController < ApplicationController
  before_action :find_resource_category, only: [:show, :update, :delete]

  def show
    render json: @resource_category
  end

  def create
    resource_category = ResourceCategory.new
    render status: 201, json: resource_category
  end

  # def update
  #   # TODO: authenticate user

  #   begin
  #     resource_category = ResourceCategory.find(params[:id])
  #   rescue ActiveRecord::RecordNotFound
  #     render status: 404, json: {} and return
  #   end

  #   attributes = params.except(:id)
  #   success = resource_category.update_attributes(attributes)


  # end
  private

  def find_resource_category
    begin
      @resource_category = ResourceCategory.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render status: 404, json: {} and return
    end
  end
end
