# frozen_string_literal: true

require 'event_router/version'
require 'event_router/error'
require 'active_job'
require 'event_router/configuration'
require 'event_router/destination'
require 'event_router/event'
require 'event_router/event_serializer'
require 'event_router/deliver_event_job'

require 'examples/notifications'
require 'examples/event_store/order_placed'
require 'examples/order_placed'
require 'examples/payment_received'

require 'pry'

module EventRouter
  module_function

  def publish(*events)
    correlation_id = events.first.correlation_id

    events.each do |event|
      event.correlation_id = correlation_id

      event.destinations.each do |name, destination|
        payload = destination.prefetch_payload? ? destination.payload_for(event) : nil

        DeliverEventJob.perform_later(name, event, payload)
      end
    end
  end

  # Configurations
  def configuration
    @configuration ||= Configuration.new
  end

  def configure
    yield configuration if block_given?
  end
end
