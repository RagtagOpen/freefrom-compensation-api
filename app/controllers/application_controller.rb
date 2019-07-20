require "#{Rails.root}/lib/helpers/api_helpers"

class ApplicationController < ActionController::API
  include APIHelpers
end
