require "#{Rails.root}/lib/helpers/api_helpers"

class ApplicationController < ActionController::API
  include APIHelpers
  include Knock::Authenticable

  private

  def authenticate_admin
    render status: 401 and return unless current_user.present? && current_user.admin?
  end
end
