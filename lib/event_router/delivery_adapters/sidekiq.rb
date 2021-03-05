# frozen_string_literal: true

require 'sidekiq'

require 'event_router/helpers/event'

require_relative 'workers/sidekiq_destination_delivery_worker'
require_relative 'workers/sidekiq_event_delivery_worker'

module EventRouter
  module DeliveryAdapters
    class Sidekiq < Base
      REQUIRED_OPTIONS = %i[queue retry].freeze

      class << self
        include EventRouter::Helpers::Event

        def validate_options!(options)
          missing_options = REQUIRED_OPTIONS - options.compact.keys

          return true if missing_options.empty?

          raise Errors::RequiredOptionError.new(options: missing_options, adapter: self)
        end

        def deliver(event, serialized_event: nil)
          serialized_event ||= EventRouter.serialize(event)

          yield_destinations(event) do |destination, serialized_payload|
            options = destination_options(destination, self)

            Workers::SidekiqDestinationDeliveryWorker
              .set(queue: options[:queue], retry: options[:retry])
              .perform_async(destination.name, serialized_event, serialized_payload)
          end
        end

        def deliver_async(event)
          serialized_event  = EventRouter.serialize(event)
          options           = EventRouter::Helpers::Event.event_options(event, self)

          Workers::SidekiqEventDeliveryWorker
            .set(queue: options[:queue], retry: options[:retry])
            .perform_async(serialized_event)
        end
      end
    end
  end
end
