# frozen_string_literal: true

require_relative 'base'

module EventRouter
  module Serializers
    class Marshal < Base
      class << self
        def serialize(object)
          ::Marshal.dump(object)
        end

        def deserialize(string)
          ::Marshal.restore(string) # rubocop:disable Security/MarshalLoad
        end
      end
    end
  end
end
