# frozen_string_literal: true

module EventRouter
  module Serializer
    module_function

    ADAPTERS = {
      json: { class_name: 'EventRouter::Serializers::Json', path: 'serializers/json' },
      oj: { class_name: 'EventRouter::Serializers::Oj', path: 'serializers/oj' }
    }.freeze

    def serialize(payload, adapter: EventRouter.configuration.serializer_adapter)
      serializer_class(adapter).serialize(payload)
    end

    def deserialize(payload, adapter: EventRouter.configuration.serializer_adapter)
      serializer_class(adapter).deserialize(payload)
    end

    def serializer_class(adapter)
      EventRouter.configuration.serializer_adapter_class(adapter)
    end
  end
end
