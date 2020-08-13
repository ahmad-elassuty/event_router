# frozen_string_literal: true

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
