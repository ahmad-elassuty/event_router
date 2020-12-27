# frozen_string_literal: true

require_relative 'base'
require 'json'

module EventRouter
  module Serializers
    class Json < Base
      EVENT_CLASS_ATTRIBUTE_NAME = 'event_class'.freeze

      class << self
        def serialize(event)
          attributes = event.to_h
          attributes[EVENT_CLASS_ATTRIBUTE_NAME] = event.class.name

          JSON.generate(attributes)
        end

        def deserialize(payload)
          attributes = JSON.parse(payload)
          event_class = attributes.delete(EVENT_CLASS_ATTRIBUTE_NAME)

          const_get(event_class).new(
            uid: attributes['uid'],
            correlation_id: attributes['correlation_id'],
            created_at: attributes['created_at'],
            **attributes['payload']
          )
        end
      end
    end
  end
end
