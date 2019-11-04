# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Knock::Authenticable

  private

  def authenticate_admin
    render status: 401 and return unless current_user.present? && current_user.admin?
  end
end
