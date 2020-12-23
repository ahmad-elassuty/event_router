# frozen_string_literal: true

require_relative 'base'
require_relative 'sidekiq_delivery_job'

module EventRouter
  module DeliveryAdapters
    class Sidekiq < Base
      class << self
        def deliver(destination, event, payload)
          serialized_event    = EventRouter::Serializer.serialize(event)
          serialized_payload  = EventRouter::Serializer.serialize(payload)

          SidekiqDeliveryJob.perform_async(destination, serialized_event, serialized_payload)
        end
      end
    end
  end
end
