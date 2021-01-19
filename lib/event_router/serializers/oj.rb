# frozen_string_literal: true

require 'oj'

module EventRouter
  module Serializers
    class Oj < Base
      class << self
        def serialize(object)
          ::Oj.dump(object, mode: :object)
        end

        def deserialize(string)
          ::Oj.load(string, mode: :object)
        end
      end
    end
  end
end
