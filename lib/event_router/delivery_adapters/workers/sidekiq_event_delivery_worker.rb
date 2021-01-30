# frozen_string_literal: true

module EventRouter
  module DeliveryAdapters
    module Workers
      class SidekiqEventDeliveryWorker
        include ::Sidekiq::Worker

        def perform(serialized_event)
          event = EventRouter.deserialize(serialized_event)

          Helpers::Sidekiq.process_event(event, serialized_event: serialized_event)
        end
      end
    end
  end
end
