# frozen_string_literal: true

module Admin
  class ResourcesController < Admin::ApplicationController
    def resource_params
      array_fields = [
        "tips",
        "resources",
        "steps",
        "challenges",
        "what_to_expect",
        "what_if_i_disagree",
      ]

      array_fields.each do |field|
        params["resource"][field] = params["resource"][field].split("\r\n\r\n*-*-*-*-*\r\n\r\n")
      end

      permitted_fields = array_fields.inject({}) do |h, field|
        h[field.to_sym] = []
        h
      end

      params.require(resource_name).permit(*dashboard.permitted_attributes, **permitted_fields)
    end
  end
end
