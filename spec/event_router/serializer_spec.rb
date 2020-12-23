RSpec.describe EventRouter::Serializer do
  let(:serializers_map) do
    {
      json: EventRouter::Serializers::Json,
      marshal: EventRouter::Serializers::Marshal,
      message_pack: EventRouter::Serializers::MessagePack
    }
  end

  describe '.serialize' do
    let(:event) { EventRouter::Event.new(order_id: 1, delivered_at: Time.current) }

    EventRouter::Serializer::ADAPTERS.each do |adapter|
      context "when adapter is set to #{adapter}" do
        subject { described_class.serialize(event, adapter: adapter) }

        let(:expected_serializer) { serializers_map[adapter] }

        it 'delegates to the serializer.serialize class method' do
          expect(expected_serializer).to receive(:serialize).once.with(event)

          subject
        end
      end
    end
  end

  describe '.deserialize' do
    let(:payload) { 'payload' }

    EventRouter::Serializer::ADAPTERS.each do |adapter|
      context "when adapter is set to #{adapter}" do
        subject { described_class.deserialize(payload, adapter: adapter) }

        let(:expected_serializer) { serializers_map[adapter] }

        it 'delegates to the serializer.deserialize class method' do
          expect(expected_serializer).to receive(:deserialize).once.with(payload)

          subject
        end
      end
    end
  end

  describe '.serializer_class' do
    EventRouter::Serializer::ADAPTERS.each do |adapter|
      context "when adapter is #{adapter}" do
        subject { described_class.serializer_class(adapter) }

        let(:expected_serializer_class) { "EventRouter::Serializers::#{adapter.to_s.camelize}Serializer".constantize }

        it { expect(subject).to eq(expected_serializer_class) }
      end
    end
  end
end
