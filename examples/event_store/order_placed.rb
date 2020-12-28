# frozen_string_literal: true

module Examples
  module EventStore
    class OrderPlaced
      def self.handle(event:, payload:)
        puts "#{'=' * 10} [EventStore] #{'=' * 10}"
        puts 'Received order_placed'
        puts event.inspect
        puts payload.inspect
        puts '=' * 32
      end
    end
  end
end
