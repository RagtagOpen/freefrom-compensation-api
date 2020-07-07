# frozen_string_literal: true

module Admin
  class ResourcesController < Admin::ApplicationController
    # rubocop:disable AbcSize
    def resource_params
      array_fields = %w[challenges resources tips steps what_if_i_disagree what_to_expect]

      array_fields.each do |field|
        next unless params['resource'][field]

        params['resource'][field] = params['resource'][field].split("\r\n\r\n*-*-*-*-*\r\n\r\n")
      end

      permitted_fields = array_fields.each_with_object({}) do |field, h|
        h[field.to_sym] = []
        h
      end

      params.require(resource_name).permit(*dashboard.permitted_attributes, **permitted_fields)
    end
    # rubocop:enable AbcSize
  end
end
