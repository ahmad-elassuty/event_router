# frozen_string_literal: true

module EventRouter
  module DeliveryAdapters
    module Helpers
      module Sidekiq
        module_function

        extend EventRouter::Helpers::Event

        def process_event(event, serialized_event: nil)
          serialized_event ||= EventRouter.serialize(event)

          yield_destinations(event) do |destination, serialized_payload|
            options = destination_options(destination, EventRouter::DeliveryAdapters::Sidekiq)

            Workers::SidekiqDestinationDeliveryWorker
              .set(queue: options[:queue], retry: options[:retry])
              .perform_async(destination.name, serialized_event, serialized_payload)
          end
        end
      end
    end
  end
end
