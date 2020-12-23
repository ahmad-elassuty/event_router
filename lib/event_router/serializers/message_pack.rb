# frozen_string_literal: true

require_relative 'base'
require 'msgpack'

module EventRouter
  module Serializers
    class MessagePack < Base
      class << self
        def setup
          ::MessagePack::DefaultFactory.register_type(0x00, Symbol)
          ::MessagePack::DefaultFactory.register_type(
            -1, Time, packer: ::MessagePack::Time::Packer, unpacker: ::MessagePack::Time::Unpacker
          )
        end

        def serialize(event)
          message = event.to_hash.merge(_er_klass: event.class.name)

          ::MessagePack.pack(message)
        end

        def deserialize(message)
          hash        = ::MessagePack.unpack(message)
          event_klass = hash.delete(:_er_klass).constantize

          event_klass.new(
            uid: hash[:uid],
            correlation_id: hash[:correlation_id],
            created_at: hash[:created_at],
            **hash[:payload]
          )
        end
      end
    end
  end
end
