# frozen_string_literal: true

require_relative 'base'
require 'oj'

module EventRouter
  module Serializers
    class Oj < Base
      class << self
        def serialize(event)
          ::Oj.dump(event, mode: :object)
        end

        def deserialize(payload)
          ::Oj.load(payload, mode: :object)
        end
      end
    end
  end
end
