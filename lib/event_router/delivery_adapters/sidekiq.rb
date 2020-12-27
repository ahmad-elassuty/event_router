# frozen_string_literal: true

require_relative 'base'
require_relative 'jobs/event_delivery_job'

module EventRouter
  module DeliveryAdapters
    class Sidekiq < Base
      def self.deliver(destination_name, event, payload)
        serialized_event    = EventRouter::Serializer.serialize(event)
        serialized_payload  = EventRouter::Serializer.serialize(payload)

        Jobs::EventDeliveryJob.perform_async(
          destination_name, serialized_event, serialized_payload
        )
      end
    end
  end
end
