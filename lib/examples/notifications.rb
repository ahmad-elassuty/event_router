# frozen_string_literal: true

module EventRouter
  module Examples
    module Notifications
    module_function

      def order_placed(event)
        binding.pry
        true
      end

      def payment_received(event)
        binding.pry
        true
      end
    end
  end
end
