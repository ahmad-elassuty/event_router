# frozen_string_literal: true

module EventRouter
  class Destination
    attr_reader :name, :handler, :handler_method

    def initialize(name, handler:, method: nil)
      @name           = name
      @handler        = handler
      @handler_method = method
    end

    def process(event)
      @handler_method ||= event.underscore_name

      handler.send(handler_method, event)
    end
  end
end
