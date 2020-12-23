# frozen_string_literal: true

module EventRouter
  module Serializers
    class Base
      class << self
        def setup; end

        def serialize(_event)
          raise NotImplementedError, 'Sub-classes must implement serialize method.'
        end

        def deserialize(_payload)
          raise NotImplementedError, 'Sub-classes must implement serialize method.'
        end
      end
    end
  end
end
