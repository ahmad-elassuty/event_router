# frozen_string_literal: true

module EventRouter
  module Examples
    module Notifications
      module_function

      def order_placed(event:, payload:)
        puts ('=' * 10) + '[Notifications]' + ('=' * 10)
        puts 'Received order_placed'
        puts event.inspect
        puts payload.inspect
        puts '=' * 35
      end

      def payment_received(event:)
        puts ('=' * 10) + '[Notifications]' + ('=' * 10)
        puts 'Received payment_received'
        puts event.inspect
        puts '=' * 35
      end
    end
  end
end
