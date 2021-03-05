# frozen_string_literal: true

module EventRouter
  module DeliveryAdapters
    module Helpers
      module DestinationDelivery
        def process_destination(destination_name, serialized_event, serialized_payload)
          event       = EventRouter.deserialize(serialized_event)
          destination = event.destinations[destination_name.to_sym]

          return unless destination

          payload = if destination.prefetch_payload?
                      EventRouter.deserialize(serialized_payload)
                    else
                      destination.extra_payload(event)
                    end

          destination.process(event, payload)
        end
      end
    end
  end
end
