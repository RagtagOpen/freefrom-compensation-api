# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!, only: %i[create destroy update]
end
