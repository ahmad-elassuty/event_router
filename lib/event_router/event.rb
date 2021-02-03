# frozen_string_literal: true

require 'securerandom'

require_relative 'destination'

module EventRouter
  class Event
    attr_reader :uid, :created_at, :payload
    attr_accessor :correlation_id

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
      self.class.name.gsub(/([a-z])([A-Z])/, '\1_\2').gsub(/.*::/, '').downcase
    end

    def destinations
      self.class.destinations
    end

    def options
      self.class.options
    end

    def options?
      !options.nil?
    end

    class << self
      attr_reader :options

      def inherited(subclass)
        subclass.instance_variable_set(:@options, @options.dup)
        subclass.instance_variable_set(:@destinations, @destinations.dup)

        super
      end

      def deliver_to(name, opts = {})
        destinations[name] = EventRouter::Destination.new(name, **opts)
      end

      def destinations
        @destinations ||= {}
      end

      def event_options(opts)
        @options = opts
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
