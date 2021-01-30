# frozen_string_literal: true

module EventRouter
  module DeliveryAdapters
    module Helpers
      module Deliver
        module_function

        def yield_destinations(event)
          event.destinations.each do |destination_name, destination|
            if destination.prefetch_payload?
              payload             = destination.extra_payload(event)
              serialized_payload  = EventRouter.serialize(payload)
            end

            yield destination_name, serialized_payload
          end
        end
      end
    end
  end
end
