# frozen_string_literal: true

require_relative 'base'
require 'json'

module EventRouter
  module Serializers
    class Json < Base
      EVENT_CLASS_ATTRIBUTE_NAME = 'er_class'.freeze

      class << self
        def serialize(object)
          return JSON.generate(object) unless object.is_a?(EventRouter::Event)

          attributes = object.to_h
          attributes[EVENT_CLASS_ATTRIBUTE_NAME] = object.class.name

          JSON.generate(attributes)
        end

        def deserialize(payload)
          object = JSON.parse(payload)

          return object unless object.is_a?(Hash)
          return object unless object.key?(EVENT_CLASS_ATTRIBUTE_NAME)

          event_class     = object.delete(EVENT_CLASS_ATTRIBUTE_NAME)
          event_instance  = const_get(event_class).new

          object.each do |attribute, value|
            event_instance.instance_variable_set(:"@#{attribute}", value)
          end

          event_instance
        end
      end
    end
  end
end
