# frozen_string_literal: true

require_relative 'delivery_adapters/memory'
require_relative 'delivery_adapters/sidekiq'

module EventRouter
  module Publisher
    module_function

    ADAPTERS = {
      memory: EventRouter::DeliveryAdapters::Memory,
      sidekiq: EventRouter::DeliveryAdapters::Sidekiq
    }.freeze

    def publish(events, delivery_adapter:)
      adapter_class = delivery_adapter_class(delivery_adapter)

      Array(events).each do |event|
        event.destinations.each do |name, destination|
          payload = destination.extra_payload(event) if destination.prefetch_payload?

          adapter_class.deliver(name, event, payload)
        end
      end
    end

    def delivery_adapter_class(adapter)
      EventRouter.configuration.delivery_adapter_class(adapter)
    end
  end
end
