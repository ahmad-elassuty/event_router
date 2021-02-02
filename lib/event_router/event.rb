# frozen_string_literal: true

require 'securerandom'
require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/string/inflections'

require_relative 'destination'

module EventRouter
  class Event
    attr_reader :uid, :created_at, :payload
    attr_accessor :correlation_id

    class_attribute :destinations, default: {}, instance_writer: false
    class_attribute :options, instance_writer: false

    def initialize(uid: SecureRandom.uuid, correlation_id: SecureRandom.uuid, created_at: Time.now, **payload)
      @uid            = uid
      @correlation_id = correlation_id
      @created_at     = created_at
      @payload        = payload
    end

    def to_hash
      {
        uid: uid,
        correlation_id: correlation_id,
        payload: payload,
        created_at: created_at
      }
    end

    alias to_h to_hash

    def name
      self.class.name.demodulize.underscore
    end

    class << self
      def inherited(base)
        base.destinations = destinations.dup
        super
      end

      def deliver_to(name, opts = {})
        destinations[name] = EventRouter::Destination.new(name, **opts)
      end

      def event_options(opts)
        self.options = opts
      end

      def publish(**attrs)
        EventRouter.publish(new(**attrs))
      end

      def publish_async(**attrs)
        EventRouter.publish_async(new(**attrs))
      end
    end
  end
end
