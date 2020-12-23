# frozen_string_literal: true

require_relative 'base'

module EventRouter
  module DeliveryAdapters
    class Memory < Base
      class << self
        def deliver(destination, event, payload)
          destination = event.destinations[destination]

          return if destination.blank?

          destination.process(event, payload || destination.extra_payload(event))
        end
      end
    end
  end
end
