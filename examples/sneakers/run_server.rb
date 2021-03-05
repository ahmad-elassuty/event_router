# frozen_string_literal: true

require 'bundler/setup'
require 'event_router'
require 'sneakers'

require_relative '../common'

logger = Logger.new(STDOUT)
logger.level = :info
Sneakers.logger = logger
Sneakers::Worker.logger = logger

EventRouter.configure do |config|
  config.register_delivery_adapter :sneakers

  config.delivery_adapter = :sneakers
end
