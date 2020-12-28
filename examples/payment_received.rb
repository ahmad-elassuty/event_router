# frozen_string_literal: true

module Examples
  class PaymentReceived < EventRouter::Event
    deliver_to :notifications,
                handler: Examples::Notifications
  end
end
