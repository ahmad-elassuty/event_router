# frozen_string_literal: true

module EventRouter
  module Examples
    module EventStore
      class OrderPlaced
        def self.handle(event)
          binding.pry
          true
        end
      end
    end
  end
end
