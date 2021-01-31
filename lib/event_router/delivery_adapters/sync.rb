# frozen_string_literal: true

module EventRouter
  module DeliveryAdapters
    class Sync < Base
      class << self
        def deliver(event)
          event.destinations.each do |_name, destination|
            payload = destination.extra_payload(event)

            destination.process(event, payload)
          end
        end

        def deliver_async(event)
          Thread.new { deliver(event) }
        end
      end
    end
  end
end
