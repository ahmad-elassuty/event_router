# frozen_string_literal: true

require "pry"

module EventRouter
  class DeliverEventJob < ActiveJob::Base
    self.queue_adapter = :sidekiq

    def perform(destination, event, payload)
      binding.pry
      event.destinations[destination]&.process(event, payload)
    end
  end
end