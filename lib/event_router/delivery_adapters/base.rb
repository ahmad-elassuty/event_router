# frozen_string_literal: true

module EventRouter
  module DeliveryAdapters
    class Base
      class << self
        def deliver(_destination, _event, _payload)
          raise NotImplementedError, "deliver method is not implemented for #{name}"
        end
      end
    end
  end
end
