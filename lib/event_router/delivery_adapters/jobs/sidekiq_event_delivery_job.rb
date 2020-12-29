# frozen_string_literal: true

require_relative '../../serializer'
require 'sidekiq'

module EventRouter
  module DeliveryAdapters
    module Jobs
      class SidekiqEventDeliveryJob
        include ::Sidekiq::Worker

        def perform(destination_name, serialized_event, serialized_payload)
          event       = EventRouter::Serializer.deserialize(serialized_event)
          destination = event.destinations[destination_name.to_sym]

          return unless destination

          payload = if destination.prefetch_payload?
                      EventRouter::Serializer.deserialize(serialized_payload)
                    else
                      destination.extra_payload(event)
                    end

          destination.process(event, payload)
        end
      end
    end
  end
end