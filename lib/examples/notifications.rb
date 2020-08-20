# frozen_string_literal: true

module EventRouter
  module Examples
    module Notifications
      module_function

      def order_placed(_args)
        true
      end

      def payment_received(_event)
        true
      end
    end
  end
end
