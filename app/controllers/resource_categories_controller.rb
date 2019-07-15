class ResourceCategoriesController < ApplicationController
  def show
    resource_category = ResourceCategory.find(params[:id])
    render json: resource_category
  end

  def update

  end
end
