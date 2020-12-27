RSpec.describe EventRouter::DeliveryAdapters::Sync do
  class DummyEvent < EventRouter::Event
    deliver_to :dummy_handler_1, handler: nil
    deliver_to :dummy_handler_2, handler: nil, prefetch_payload: true

    def dummy_handler_1_payload
      { id: 't1' }
    end

    def dummy_handler_2_payload
      { id: 't2' }
    end
  end

  describe '.deliver' do
    subject { described_class.deliver(destination_name, event, payload) }

    let(:destination_name)  { :dummy_handler_1 }
    let(:event)             { DummyEvent.new }
    let(:payload)           { nil }
    let(:destination)       { event.destinations[destination_name] }

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
