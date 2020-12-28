# frozen_string_literal: true

module EventRouter
  module Publisher
    module_function

    ADAPTERS = {
      sync: { class_name: 'EventRouter::DeliveryAdapters::Sync', path: 'delivery_adapters/sync' },
      sidekiq: { class_name: 'EventRouter::DeliveryAdapters::Sidekiq', path: 'delivery_adapters/sidekiq' }
    }.freeze

    def publish(events, adapter:)
      Array(events).each { |event| delivery_adapter_class(adapter).deliver(event) }
    end

    def delivery_adapter_class(adapter)
      EventRouter.configuration.delivery_adapter_class(adapter)
    end
  end
end
