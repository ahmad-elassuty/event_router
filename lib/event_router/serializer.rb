# frozen_string_literal: true

require_relative 'serializers/json'
require_relative 'serializers/oj'
require_relative 'serializers/marshal'

module EventRouter
  module Serializer
    module_function

    ADAPTERS = {
      marshal: EventRouter::Serializers::Marshal,
      json: EventRouter::Serializers::Json,
      oj: EventRouter::Serializers::Oj
    }.freeze

    def setup(adapter)
      serializer_class(adapter).setup
    end

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
