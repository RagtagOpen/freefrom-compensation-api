# frozen_string_literal: true

module Updateable
  extend ActiveSupport::Concern

  module ClassMethods
    def upsert_params
      params = self.new.attributes.map do |key, value|
        value == [] ? { key.to_sym => value } : key.to_sym
      end
    end
  end
end
