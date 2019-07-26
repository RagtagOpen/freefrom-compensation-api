require "#{Rails.root}/lib/helpers/api_helpers"

class ApplicationController < ActionController::API
  include APIHelpers
  include Knock::Authenticable

  private

  def authenticate_admin
    return_unauthorized unless !current_user.nil? && current_user.admin?
  end
end
