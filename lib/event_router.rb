require "event_router/version"
require "event_router/error"
require "active_job"
require "event_router/destination"
require "event_router/event"
require "event_router/event_serializer"
require "event_router/deliver_event_job"

require "examples/order_placed"

require "pry"

module EventRouter
  module_function

  def run_example
    ActiveJob::Serializers.add_serializers EventSerializer

    Examples::OrderPlaced.publish(order_id: 1)
  end

  def publish(event)
    DeliverEventJob.perform_later(:notifications, event)
  end

  # def publish(events)
  #   events = Array(events)
  #
  #   events.map(&:destinations).flatten.each do |destination|
  #     DeliverEventJob.perform_later(destination, event: event)
  #   end
  # end
end
