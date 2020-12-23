RSpec.describe EventRouter::Serializer do
  describe '.serialize' do
    let(:event) { EventRouter::Event.new(order_id: 1, delivered_at: Time.now) }

    EventRouter::Serializer::ADAPTERS.each do |adapter, adapter_class|
      context "when adapter is set to #{adapter}" do
        subject { described_class.serialize(event, adapter: adapter) }

        it 'delegates to the serializer.serialize class method' do
          expect(adapter_class).to receive(:serialize).once.with(event)

          subject
        end
      end
    end
  end

  describe '.deserialize' do
    let(:payload) { 'payload' }

    EventRouter::Serializer::ADAPTERS.each do |adapter, adapter_class|
      context "when adapter is set to #{adapter}" do
        subject { described_class.deserialize(payload, adapter: adapter) }

        it 'delegates to the serializer.deserialize class method' do
          expect(adapter_class).to receive(:deserialize).once.with(payload)

          subject
        end
      end
    end
  end

  describe '.serializer_class' do
    EventRouter::Serializer::ADAPTERS.each do |adapter, adapter_class|
      context "when adapter is #{adapter}" do
        subject { described_class.serializer_class(adapter) }

        it { expect(subject).to eq(adapter_class) }
      end
    end
  end
end
