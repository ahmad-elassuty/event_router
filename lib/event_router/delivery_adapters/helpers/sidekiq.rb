# frozen_string_literal: true

module EventRouter
  module DeliveryAdapters
    module Helpers
      module Sidekiq
        module_function

        def process_event(event, serialized_event: nil)
          serialized_event ||= EventRouter.serialize(event)

          options = EventRouter::DeliveryAdapters::Sidekiq.options

          Helpers::Deliver.yield_destinations(event) do |destination_name, serialized_payload|
            Workers::SidekiqDestinationDeliveryWorker
              .set(queue: options[:queue], retry: options[:retry])
              .perform_async(destination_name, serialized_event, serialized_payload)
          end
        end
      end
    end
  end
end
