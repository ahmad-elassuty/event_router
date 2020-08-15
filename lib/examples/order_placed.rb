# frozen_string_literal: true

module EventRouter
  module Examples
    class OrderPlaced < EventRouter::Event
      deliver_to :notifications,
        handler: EventRouter::Examples::Notifications

      deliver_to :event_store,
        handler: EventRouter::Examples::EventStore::OrderPlaced,
        method: :handle,
        prefetch_payload: true

      # Custom payload methods
      def notifications_payload
        {
          id: payload[:order_id],
          notification_name: :first_order
        }
      end

      def event_store_payload
        {
          id: payload[:order_id]
        }
      end
    end
  end
end