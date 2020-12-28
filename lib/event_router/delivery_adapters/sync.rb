# frozen_string_literal: true

require_relative 'base'

module EventRouter
  module DeliveryAdapters
    class Sync < Base
      def self.deliver(event)
        event.destinations.each do |name, destination|
          payload = destination.extra_payload(event)

          destination.process(event, payload)
        end
      end
    end
  end
end
