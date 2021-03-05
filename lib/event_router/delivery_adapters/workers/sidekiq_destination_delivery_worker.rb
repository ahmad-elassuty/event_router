# frozen_string_literal: true

module EventRouter
  module DeliveryAdapters
    module Workers
      class SidekiqDestinationDeliveryWorker
        include ::Sidekiq::Worker
        include DeliveryAdapters::Helpers::DestinationDelivery

        def perform(destination_name, serialized_event, serialized_payload)
          process_destination(destination_name, serialized_event, serialized_payload)
        end
      end
    end
  end
end
