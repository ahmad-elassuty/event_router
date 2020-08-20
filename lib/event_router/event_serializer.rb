# frozen_string_literal: true

module EventRouter
  class EventSerializer < ActiveJob::Serializers::ObjectSerializer
    def serialize(event)
      event_attrs         = event.to_hash
      payload             = event_attrs.delete(:payload)
      serialized_payload  = ActiveJob::Arguments.serialize(payload)
      serialized_event    = super(event_attrs)

      serialized_event.merge(payload: serialized_payload)
    end

    def deserialize(hash)
      hash['_er_klass'].constantize.new(
        uid: hash['uid'],
        correlation_id: hash['correlation_id'],
        created_at: Time.parse(hash['created_at']),
        **ActiveJob::Arguments.deserialize(hash['payload']).to_h
      )
    end

    private

    def klass
      Event
    end
  end
end
