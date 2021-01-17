# frozen_string_literal: true

module EventRouter
  module Serializer
    module_function

    ADAPTERS = {
      json: { adapter_class: 'EventRouter::Serializers::Json', path: 'serializers/json' },
      oj: { adapter_class: 'EventRouter::Serializers::Oj', path: 'serializers/oj' }
    }.freeze

    def serialize(payload, adapter:)
      serializer_adapter(adapter).serialize(payload)
    end

    def deserialize(payload, adapter:)
      serializer_adapter(adapter).deserialize(payload)
    end

    def serializer_adapter(adapter)
      EventRouter.configuration.serializer_adapter_class(adapter)
    end

    private_class_method :serializer_adapter
  end
end
