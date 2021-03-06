# frozen_string_literal: true

module EventRouter
  class Destination
    # Attributes
    attr_reader :name, :handler, :handler_method,
                :prefetch_payload, :payload_method,
                :options

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
      @handler_method   = opts.delete(:handler_method)
      @prefetch_payload = opts.delete(:prefetch_payload)
      @payload_method   = opts.delete(:payload_method) || "#{name}_payload"
      @options          = opts
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

    def extra_payload(event)
      return nil unless event.respond_to?(payload_method)

      event.send(payload_method)
    end
  end
end
