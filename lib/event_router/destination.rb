# frozen_string_literal: true

module EventRouter
  class Destination
    attr_reader :name, :handler, :handler_method

    def initialize(name, handler:, method: nil, prefetch_payload: false)
      @name             = name
      @handler          = handler
      @handler_method   = method
      @prefetch_payload = prefetch_payload
    end

    def process(event, payload)
      handler.send(
        handler_method || event.name,
        event: event,
        payload: payload || payload_for(event)
      )
    end

    def prefetch_payload?
      @prefetch_payload
    end

    def payload_for(event)
      return event.payload unless custom_payload?(event)

      event.send(payload_method_name)
    end

    def custom_payload?(event)
      event.respond_to?(payload_method_name)
    end

    def payload_method_name
      "#{name}_payload"
    end
  end
end
