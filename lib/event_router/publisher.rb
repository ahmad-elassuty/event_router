# frozen_string_literal: true

module EventRouter
  module Publisher
    module_function

    ADAPTERS = {
      sync: { adapter_class: 'EventRouter::DeliveryAdapters::Sync', path: 'delivery_adapters/sync' },
      sidekiq: { adapter_class: 'EventRouter::DeliveryAdapters::Sidekiq', path: 'delivery_adapters/sidekiq' }
    }.freeze

    def publish(events, adapter:)
      adapter_class = delivery_adapter(adapter)

      Array(events).each { |event| adapter_class.deliver(event) }
    end

    def delivery_adapter(adapter)
      EventRouter.configuration.delivery_adapter_class(adapter)
    end

    private_class_method :delivery_adapter
  end
end
