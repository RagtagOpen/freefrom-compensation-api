class ResourceCategoriesController < ApplicationController
  def show
    begin
      resource_category = ResourceCategory.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render status: 404, json: {} and return
    end
    render json: resource_category
  end

  def update

  end
end
