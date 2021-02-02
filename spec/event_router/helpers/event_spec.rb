require 'event_router/helpers/event'

RSpec.describe EventRouter::Helpers::Event do
  describe '.yield_destinations' do
    subject { described_class.yield_destinations(event) }

    let(:event) { DummyEvent.new }

    let(:expected_args) do
      event.destinations.map { |_, destination| [destination, anything] }
    end

    it 'yields the event destinations with serialized payload' do
      expect { |b| described_class.yield_destinations(event, &b) }.to yield_successive_args(*expected_args)
    end

    it 'serializes the payload' do
      expect(EventRouter).to receive(:serialize).once

      subject
    end
  end

  describe '.event_options' do
    subject { described_class.event_options(event, adapter) }

    let(:event)           { DummyEvent.new }
    let(:adapter)         { DummyDeliveryAdapter }
    let(:adapter_options) { { option_1: :adapter, option_2: :adapter } }

    before { allow(adapter).to receive(:options) { adapter_options } }

    context 'when event has custom options' do
      let(:event_options) { { option_1: :event } }

      before { allow(event).to receive(:options) { event_options } }

      it 'merges the event options to the adapter options' do
        is_expected.to eq(option_1: :event, option_2: :adapter)
      end
    end

    context 'when event does not have any custom options' do
      it 'returns the adapter options' do
        is_expected.to eq(adapter_options)
      end
    end
  end

  describe '.destination_options' do
    subject { described_class.destination_options(destination, adapter) }

    let(:adapter)         { DummyDeliveryAdapter }
    let(:adapter_options) { { option_1: :adapter, option_2: :adapter } }

    before { allow(adapter).to receive(:options) { adapter_options } }

    context 'when destination has custom options' do
      let(:destination) { EventRouter::Destination.new(:notifications, handler: :any, option_1: :destination) }

      it 'merges the destination options to the adapter options' do
        is_expected.to eq(option_1: :destination, option_2: :adapter)
      end
    end

    context 'when destination does not have any custom options' do
      let(:destination) { EventRouter::Destination.new(:notifications, handler: :any) }

      it 'returns the adapter options' do
        is_expected.to eq(adapter_options)
      end
    end
  end
end
