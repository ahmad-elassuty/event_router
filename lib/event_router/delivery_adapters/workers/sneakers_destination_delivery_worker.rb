# frozen_string_literal: true

module EventRouter
  module DeliveryAdapters
    module Workers
      class SneakersDestinationDeliveryWorker
        include ::Sneakers::Worker
        include DeliveryAdapters::Helpers::DestinationDelivery

        from_queue :event_router

        def work(serialized_message)
          message = EventRouter.deserialize(serialized_message)

          destination_name    = message['destination_name']
          serialized_event    = message['serialized_event']
          serialized_payload  = message['serialized_payload']

          process_destination(destination_name, serialized_event, serialized_payload)

          ack!
        end
      end
    end
  end
end
