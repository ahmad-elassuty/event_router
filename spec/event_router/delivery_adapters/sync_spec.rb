require 'event_router/delivery_adapters/sync'

RSpec.describe EventRouter::DeliveryAdapters::Sync do
  describe '.deliver' do
    subject { described_class.deliver(event) }

    let(:event) { DummyEvent.new }

    before do
      allow(destination).to receive(:process) { true }
    end

    context 'when destination is missing' do
      let(:destination_name) { :invalid_destination }

      it { expect { described_class }.to_not raise_error }
    end

    context 'when prefetch is enabled' do
      let(:destination_name) { :dummy_handler_2 }

      it 'does not fetch the extra payload' do
        expect(event).to_not receive(:dummy_handler_1_payload)

        subject
      end

      it 'it delegates to the destination' do
        expect(destination).to receive(:process).once.with(event, payload)

        subject
      end
    end
  end
end
