# frozen_string_literal: true

require_relative '../error'

module EventRouter
  module Errors
    class RequiredOptionError < Error
      def initialize(message: nil, options:, adapter:)
        @options = options
        @adapter = adapter

        super(message || self.message)
      end

      def message
        "#{@options} are required for #{@adapter} adapter."
      end
    end
  end
end
