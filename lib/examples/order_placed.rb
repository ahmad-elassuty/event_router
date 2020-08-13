# frozen_string_literal: true

require_relative "notifications"
require_relative "event_store/order_placed"

module EventRouter
  module Examples
    class OrderPlaced < EventRouter::Event
      deliver_to :notifications,
        handler: EventRouter::Examples::Notifications

      deliver_to :event_store,
        handler: EventRouter::Examples::EventStore::OrderPlaced,
        method: :handle
    end
  end
end
