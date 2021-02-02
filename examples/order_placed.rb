# frozen_string_literal: true

module Examples
  class OrderPlaced < EventRouter::Event
    event_options queue: :orders, retry: false

    deliver_to :notifications,
               handler: Examples::Notifications,
               queue: :notifications

    deliver_to :event_store,
               handler: Examples::EventStore::OrderPlaced,
               handler_method: :handle,
               prefetch_payload: true,
               payload_method: :store_payload

    # Extra payload
    def store_payload
      {
        id: SecureRandom.uuid
      }
    end
  end
end
