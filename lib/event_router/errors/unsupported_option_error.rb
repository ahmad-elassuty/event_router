# frozen_string_literal: true

require_relative '../error'

module EventRouter
  module Errors
    class UnsupportedOptionError < Error
      def initialize(message: nil, config:, option:, supported_options:)
        @config             = config
        @option             = option
        @supported_options  = supported_options

        super(message || self.message)
      end

      def message
        "Unsupported #{@option} for #{@config} configuration. Currently supports #{@supported_options}. " \
          "Please consider registering the adapter before referencing it."
      end
    end
  end
end
