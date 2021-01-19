# frozen_string_literal: true

require 'event_router'

require_relative '../common'

EventRouter.configure do |config|
  config.register_delivery_adapter :sidekiq, queue: :event_router, retry: 5

  config.delivery_adapter = :sidekiq
end
