# frozen_string_literal: true

module EventRouter
  module Helpers
    module Event
      module_function

      def yield_destinations(event)
        event.destinations.each do |_name, destination|
          if destination.prefetch_payload?
            payload             = destination.extra_payload(event)
            serialized_payload  = EventRouter.serialize(payload)
          end

          yield destination, serialized_payload if block_given?
        end
      end

      def event_options(event, adapter)
        return adapter.options unless event.options?

        adapter.options.merge(event.options)
      end

      def destination_options(destination, adapter)
        adapter.options.merge(destination.options)
      end
    end
  end
end
