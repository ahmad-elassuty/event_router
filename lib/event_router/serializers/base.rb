# frozen_string_literal: true

module EventRouter
  module Serializers
    class Base
      class << self
        def serialize(_object)
          raise NotImplementedError, 'Sub-classes must implement serialize method.'
        end

        def deserialize(_string)
          raise NotImplementedError, 'Sub-classes must implement serialize method.'
        end
      end
    end
  end
end
