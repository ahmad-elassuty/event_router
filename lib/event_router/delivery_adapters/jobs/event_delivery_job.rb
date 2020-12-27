# frozen_string_literal: true

require_relative '../../serializer'
require 'active_support/core_ext/object/blank'
require 'sidekiq'

module EventRouter
  module DeliveryAdapters
    module Jobs
      class EventDeliveryJob
        include ::Sidekiq::Worker

        sidekiq_options queue: :event_router, retry: 5

        def perform(destination_name, serialized_event, serialized_payload)
          event       = EventRouter::Serializer.deserialize(serialized_event)
          destination = event.destinations[destination_name.to_sym]

          return if destination.blank?

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
