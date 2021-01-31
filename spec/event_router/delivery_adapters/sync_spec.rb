require 'event_router/delivery_adapters/sync'

RSpec.describe EventRouter::DeliveryAdapters::Sync do
  let(:event) { DummyEvent.new }

  describe '.deliver' do
    subject { described_class.deliver(event) }

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

  describe '.deliver_async' do
    subject { described_class.deliver_async(event) }

    before { allow(described_class).to receive(:deliver) { true } }

    it 'schedules a thread' do
      expect(subject).to be_instance_of(Thread)
    end

    it 'delegates to deliver method' do
      subject.join

      expect(described_class).to have_received(:deliver).once.with(event)
    end
  end
end
