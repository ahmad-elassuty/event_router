# frozen_string_literal: true

require_relative 'errors/unsupported_option_error'
require_relative 'serializer'
require_relative 'publisher'

module EventRouter
  class Configuration
    attr_reader :delivery_adapter, :serializer_adapter, :delivery_adapters, :serializer_adapters

    def initialize
      @delivery_adapter     = :sync
      @serializer_adapter   = :json
      @delivery_adapters    = Publisher::ADAPTERS
      @serializer_adapters  = Serializer::ADAPTERS
    end

    def delivery_adapter=(adapter)
      validate_inclusion(:delivery_adapter, adapter, @delivery_adapters)

      @delivery_adapter = adapter
    end

    def delivery_adapter_class(name)
      @delivery_adapters[name]
    end

    def register_delivery_adapter(name, delivery_adapter_class)
      @delivery_adapters[name] = delivery_adapter_class
    end

    def serializer_adapter=(adapter)
      validate_inclusion(:serializer_adapter, adapter, @serializer_adapters)

      Serializer.setup(adapter)
      @serializer_adapter = adapter
    end

    def serializer_adapter_class(name)
      @serializer_adapters[name]
    end

    def register_serializer(name, serializer_adapter_class)
      @serializer_adapters[name] = serializer_adapter_class
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
