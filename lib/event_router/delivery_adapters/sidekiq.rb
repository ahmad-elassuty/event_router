# frozen_string_literal: true

require_relative 'jobs/sidekiq_event_delivery_job'

module EventRouter
  module DeliveryAdapters
    class Sidekiq < Base
      REQUIRED_OPTIONS = %i[queue retry]

      class << self
        def validate_options!(options)
          missing_options = REQUIRED_OPTIONS - options.compact.keys

          return true if missing_options.empty?

          raise Errors::RequiredOptionError.new(options: missing_options, adapter: self)
        end

        def deliver(event)
          serialized_event = EventRouter.serialize(event)

          event.destinations.each do |name, destination|
            if destination.prefetch_payload?
              payload             = destination.extra_payload(event)
              serialized_payload  = EventRouter.serialize(payload)
            end

            Jobs::SidekiqEventDeliveryJob
              .set(queue: options[:queue], retry: options[:retry])
              .perform_async(name, serialized_event, serialized_payload)
          end
        end
      end
    end
  end
end
