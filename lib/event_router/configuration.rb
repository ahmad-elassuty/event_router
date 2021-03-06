# frozen_string_literal: true

require_relative 'errors/unsupported_option_error'

module EventRouter
  class Configuration
    attr_reader :delivery_adapter, :delivery_adapters,
                :serializer_adapter, :serializer_adapters

    def initialize
      @delivery_adapters    = {}
      @serializer_adapters  = {}

      register_delivery_adapter(:sync)
      @delivery_adapter = :sync

      register_serializer_adapter(:json)
      @serializer_adapter = :json
    end

    def delivery_adapter=(adapter, _opts = {})
      validate_inclusion!(:delivery_adapter, adapter, @delivery_adapters)

      @delivery_adapter = adapter
    end

    def delivery_adapter_class(adapter)
      @delivery_adapters[adapter]
    end

    def register_delivery_adapter(adapter, opts = {})
      adapter_class = load_adapter_class(Publisher::ADAPTERS, adapter) || opts[:adapter_class]

      adapter_class.options       = opts
      @delivery_adapters[adapter] = adapter_class
    end

    def serializer_adapter=(adapter)
      validate_inclusion!(:serializer_adapter, adapter, @serializer_adapters)

      @serializer_adapter = adapter
    end

    def serializer_adapter_class(adapter)
      @serializer_adapters[adapter]
    end

    def register_serializer_adapter(adapter, opts = {})
      adapter_class = load_adapter_class(Serializer::ADAPTERS, adapter) || opts[:adapter_class]

      @serializer_adapters[adapter] = adapter_class
    end

    private

    def load_adapter_class(adapters, adapter)
      return nil unless adapters.key?(adapter)

      require_relative adapters[adapter][:path]
      Kernel.const_get(adapters[adapter][:adapter_class])
    end

    def validate_inclusion!(config, option, supported_options)
      return if supported_options.include?(option)

      raise Errors::UnsupportedOptionError.new(
        config: config, option: option, supported_options: supported_options.keys
      )
    end
  end
end
