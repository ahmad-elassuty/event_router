# frozen_string_literal: true

module EventRouter
  class Destination
    # Attributes
    attr_reader :name, :handler, :handler_method,
                :prefetch_payload, :payload_method

    # Constants
    DEFAULT_ATTRIBUTES = {
      # Defaults to the event name, e.g "order_placed"
      handler_method: nil,
      # Defaults to not fetch before scheduling the job.
      prefetch_payload: false,
      # Defaults to destination name, e.g "#{name}_payload"
      payload_method: nil
    }.freeze

    # Methods
    def initialize(name, handler:, **opts)
      opts = DEFAULT_ATTRIBUTES.merge(opts)

      @name             = name
      @handler          = handler
      @handler_method   = opts[:handler_method]
      @prefetch_payload = opts[:prefetch_payload]
      @payload_method   = opts[:payload_method] || "#{name}_payload"
    end

    def process(event, payload)
      handler.send(
        handler_method || event.name,
        event: event,
        payload: payload
      )
    end

    def prefetch_payload?
      @prefetch_payload
    end

    def payload_for(event)
      return event.payload unless custom_payload?(event)

      event.send(payload_method)
    end

    def custom_payload?(event)
      event.respond_to?(payload_method)
    end
  end
end
