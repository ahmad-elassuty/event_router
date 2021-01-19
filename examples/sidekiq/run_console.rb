# frozen_string_literal: true

require 'bundler/setup'
require 'event_router'
require 'pry'

require_relative '../common'

EventRouter.configure do |config|
  config.register_delivery_adapter :sidekiq, queue: :event_router, retry: 5

  config.delivery_adapter = :sidekiq
end

Pry.start
