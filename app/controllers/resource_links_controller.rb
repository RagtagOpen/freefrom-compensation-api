# frozen_string_literal: true

class ResourceLinksController < ApplicationController
  before_action :authenticate_admin, only: %i[create destroy update]
  before_action :find_resource_link, only: %i[destroy show update]

  def show
    render json: @resource_link
  end

  def create
    @resource_link = ResourceLink.new(resource_id: params[:resource_id])

    begin
      @resource_link.save!
    rescue ActiveRecord::RecordInvalid => e
      render status: 400, json: { error: e.message } and return
    end
    render status: 201, json: @resource_link
  end

  def destroy
    @resource_link.destroy
    render status: 204, json: {}
  end

  def update
    begin
      attributes = params.permit(ResourceLink.update_params)
      @resource_link.update!(attributes)
    rescue ActiveRecord::RecordInvalid => e
      render status: 400, json: { error: e.message } and return
    end

    render json: @resource_link
  end

  private

  def find_resource_link
    @resource_link = ResourceLink.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render status: 404, json: {} and return
  end
end
