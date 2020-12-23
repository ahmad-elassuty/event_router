# frozen_string_literal: true

require_relative 'base'

module EventRouter
  module Serializers
    class Marshal < Base
      class << self
        def serialize(event)
          ::Marshal.dump(event)
        end

        def deserialize(payload)
          ::Marshal.restore(payload)
        end
      end
    end
  end
end
