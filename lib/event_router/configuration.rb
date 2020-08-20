# frozen_string_literal: true

require_relative 'errors/unsupported_option_error'

module EventRouter
  class Configuration
    attr_reader :delivery_adapter, :delivery_strategy

    # Constants
    DELIVERY_ADAPTERS = %i[
      memory
    ].freeze

    DELIVERY_STRATEGIES = %i[
      async
      sync
    ].freeze

    DEFAULT_CONFIGURATIONS = {
      delivery_adapter: :memory,
      delivery_strategy: :async
    }.freeze

    def initialize
      @delivery_adapter   = DEFAULT_CONFIGURATIONS[:delivery_adapter]
      @delivery_strategy  = DEFAULT_CONFIGURATIONS[:delivery_strategy]
    end

    def delivery_adapter=(adapter)
      validate_inclusion(:delivery_adapter, adapter, DELIVERY_ADAPTERS)

      @delivery_adapter = adapter
    end

    def delivery_strategy=(strategy)
      validate_inclusion(:delivery_strategy, strategy, DELIVERY_STRATEGIES)

      @delivery_strategy = strategy
    end

    private

    def validate_inclusion(config, option, supported_options)
      return if supported_options.include?(option)

      raise Errors::UnsupportedOptionError.new(
        config: config, option: option, supported_options: supported_options
      )
    end
  end
end
