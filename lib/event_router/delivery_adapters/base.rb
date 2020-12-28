# frozen_string_literal: true

require_relative '../errors/required_option_error'

module EventRouter
  module DeliveryAdapters
    class Base
      class << self
        attr_reader :options

        def options=(options)
          validate_options!(options)

          @options = options
        end

        def validate_options!(_options)
          true
        end

        def deliver(event)
          raise NotImplementedError, "deliver method is not implemented for #{name}"
        end
      end
    end
  end
end
