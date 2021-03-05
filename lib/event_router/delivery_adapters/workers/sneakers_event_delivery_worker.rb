# frozen_string_literal: true

module EventRouter
  module DeliveryAdapters
    module Workers
      class SneakersEventDeliveryWorker
        include Sneakers::Worker

        from_queue :event_router

        def work(serialized_event)
          event = EventRouter.deserialize(serialized_event)

          DeliveryAdapters::Sneakers.deliver(event, serialized_event: serialized_event)

          ack!
        end
      end
    end
  end
end
