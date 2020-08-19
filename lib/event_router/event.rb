# frozen_string_literal: true

require 'securerandom'

module EventRouter
  class Event
    attr_reader :uid, :created_at, :payload
    attr_accessor :correlation_id

    class_attribute :destinations, default: {}, instance_writer: false

    def initialize(uid: SecureRandom.uuid, correlation_id: SecureRandom.uuid, created_at: Time.current, **payload)
      @uid            = uid
      @correlation_id = correlation_id
      @created_at     = created_at
      @payload        = payload
    end

    def to_hash
      {
        uid: uid,
        correlation_id: correlation_id,
        name: name,
        payload: payload,
        created_at: created_at,
        _er_klass: self.class.name
      }
    end

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

      def publish(**attrs)
        EventRouter.publish(new(**attrs))
      end
    end
  end
end
