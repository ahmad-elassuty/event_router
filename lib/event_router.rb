# frozen_string_literal: true

require 'event_router/version'
require 'event_router/error'

require 'event_router/event'
require 'event_router/delivery_adapters/base'
require 'event_router/serializers/base'
require 'event_router/publisher'
require 'event_router/serializer'
require 'event_router/configuration'

module EventRouter
  module_function

  def publish(events, adapter: EventRouter.configuration.delivery_adapter)
    EventRouter::Publisher.publish(events, adapter: adapter)
  end

  def publish_async(events, adapter: EventRouter.configuration.delivery_adapter)
    EventRouter::Publisher.publish_async(events, adapter: adapter)
  end

  def serialize(event, adapter: EventRouter.configuration.serializer_adapter)
    EventRouter::Serializer.serialize(event, adapter: adapter)
  end

  def deserialize(payload, adapter: EventRouter.configuration.serializer_adapter)
    EventRouter::Serializer.deserialize(payload, adapter: adapter)
  end

  def configuration
    @configuration ||= Configuration.new
  end

  def configure
    yield configuration if block_given?
  end
end
