# frozen_string_literal: true

require 'pry'

module EventRouter
  class DeliverEventJob < ActiveJob::Base
    self.queue_adapter = :sidekiq

    def perform(destination, event, payload)
      destination = event.destinations[destination]

      return if destination.blank?

      payload ||= destination.payload_for(event)
      destination.process(event, payload)
    end
  end
end
