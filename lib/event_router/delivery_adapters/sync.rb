# frozen_string_literal: true

module EventRouter
  module DeliveryAdapters
    class Sync < Base
      def self.deliver(event)
        event.destinations.each do |_name, destination|
          payload = destination.extra_payload(event)

          destination.process(event, payload)
        end
      end
    end
  end
end
