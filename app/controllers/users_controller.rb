class UsersController < ApplicationController
  def current
    if current_user.present?
      render json: current_user
    else
      render status: 401, json: {}
    end
  end
end
