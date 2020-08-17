require "event_router/version"
require "event_router/error"
require "active_job"
require "event_router/configuration"
require "event_router/destination"
require "event_router/event"
require "event_router/event_serializer"
require "event_router/deliver_event_job"

require "examples/notifications"
require "examples/event_store/order_placed"
require "examples/order_placed"
require "examples/payment_received"

require "pry"

module EventRouter
  module_function

  def schedule_single_event
    ActiveJob::Serializers.add_serializers EventSerializer

    Examples::OrderPlaced.publish(order_id: 1)
  end

  def schedule_multiple_events
    ActiveJob::Serializers.add_serializers EventSerializer

    event_1 = Examples::OrderPlaced.new(order_id: 1)
    event_2 = Examples::PaymentReceived.new(order_id: 2)

    publish(event_1, event_2)
  end

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
