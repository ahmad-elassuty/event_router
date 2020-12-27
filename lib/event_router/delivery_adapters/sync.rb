# frozen_string_literal: true

require_relative 'base'

module EventRouter
  module DeliveryAdapters
    class Sync < Base
      class << self
        def deliver(destination, event, payload)
          destination = event.destinations[destination]

          return if destination.blank?

          payload = destination.prefetch_payload? ? payload : destination.extra_payload(event)

          destination.process(event, payload)
        end
      end
    end
  end
end
