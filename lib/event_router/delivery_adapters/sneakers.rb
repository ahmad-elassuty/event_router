# frozen_string_literal: true

require 'sneakers'

require_relative 'workers/sneakers_destination_delivery_worker'
require_relative 'workers/sneakers_event_delivery_worker'

module EventRouter
  module DeliveryAdapters
    class Sneakers < Base
      class << self
        include EventRouter::Helpers::Event

        def deliver(event, serialized_event: nil)
          serialized_event ||= EventRouter.serialize(event)

          yield_destinations(event) do |destination, serialized_payload|
            options = destination_options(destination, self)

            message = {
              destination_name: destination.name,
              serialized_event: serialized_event,
              serialized_payload: serialized_payload
            }

            serialized_message = EventRouter.serialize(message)

            Workers::SneakersDestinationDeliveryWorker.from_queue(options[:queue])
            Workers::SneakersDestinationDeliveryWorker.enqueue(serialized_message)
          end
        end

        def deliver_async(event)
          serialized_event = EventRouter.serialize(event)

          Workers::SneakersEventDeliveryWorker.enqueue(serialized_event)
        end
      end
    end
  end
end
