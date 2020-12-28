# frozen_string_literal: true

require 'event_router/version'
require 'event_router/error'

require 'event_router/event'
require 'event_router/publisher'
require 'event_router/serializer'
require 'event_router/configuration'

module EventRouter
  module_function

  def publish(events, adapter: EventRouter.configuration.delivery_adapter)
    EventRouter::Publisher.publish(events, adapter: adapter)
  end

  def configuration
    @configuration ||= Configuration.new
  end

  def configure
    yield configuration if block_given?
  end
end
