require 'event_router/delivery_adapters/sync'

RSpec.describe EventRouter::DeliveryAdapters::Sync do
  describe '.deliver' do
    subject { described_class.deliver(event) }

    let(:event) { DummyEvent.new }

    it 'fetches the extra payload once per destination' do
      event.destinations.each do |_name, destination|
        expect(destination).to receive(:extra_payload).once.with(event)
      end

      subject
    end

    it 'delivers the event once per destination' do
      event.destinations.each do |_name, destination|
        expect(destination).to receive(:process)
          .once.with(event, destination.extra_payload(event))
      end

      subject
    end
  end
end
