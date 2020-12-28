# frozen_string_literal: true

require 'bundler/setup'
require 'event_router'

require_relative '../common'

EventRouter.configure do |config|
  config.delivery_adapter = :sync
end

require 'pry'
Pry.start
