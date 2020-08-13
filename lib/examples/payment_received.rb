# frozen_string_literal: true

module EventRouter
  module Examples
    class PaymentReceived < EventRouter::Event
      deliver_to :notifications,
        handler: EventRouter::Examples::Notifications
    end
  end
end
