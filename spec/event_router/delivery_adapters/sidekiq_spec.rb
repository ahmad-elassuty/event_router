require 'event_router/delivery_adapters/sidekiq'

RSpec.describe EventRouter::DeliveryAdapters::Sidekiq do
  let(:event)             { DummyEvent.new }
  let(:serialized_event)  { EventRouter.serialize(event) }
  let(:adapter_options)   { { queue: :default, retry: 1 } }

  before { allow(described_class).to receive(:options) { adapter_options } }

  describe '.deliver' do
    subject { described_class.deliver(event) }

    let(:enabled_prefetch_destinations)   { event.destinations.select { |_k, v| v.prefetch_payload? } }
    let(:disabled_prefetch_destinations)  { event.destinations.reject { |_k, v| v.prefetch_payload? } }

    it 'schedules one worker per destination' do
      enabled_prefetch_destinations.each do |name, destination|
        serialized_payload = EventRouter.serialize(destination.extra_payload(event))

        expect(EventRouter::DeliveryAdapters::Workers::SidekiqDestinationDeliveryWorker).to receive(:client_push)
          .with(
            'args' => [name, serialized_event, serialized_payload],
            'class' => EventRouter::DeliveryAdapters::Workers::SidekiqDestinationDeliveryWorker,
            :queue => adapter_options[:queue],
            :retry => adapter_options[:retry]
          )
      end

      disabled_prefetch_destinations.each do |name, _destination|
        expect(EventRouter::DeliveryAdapters::Workers::SidekiqDestinationDeliveryWorker).to receive(:client_push)
          .with(
            'args' => [name, serialized_event, nil],
            'class' => EventRouter::DeliveryAdapters::Workers::SidekiqDestinationDeliveryWorker,
            :queue => adapter_options[:queue],
            :retry => adapter_options[:retry]
          )
      end

      subject
    end
  end

  describe '.deliver_async' do
    subject { described_class.deliver_async(event) }

    it 'schedules one worker to publish the event' do
      expect(EventRouter::DeliveryAdapters::Workers::SidekiqEventDeliveryWorker).to receive(:client_push)
        .once
        .with(
          'args' => [serialized_event],
          'class' => EventRouter::DeliveryAdapters::Workers::SidekiqEventDeliveryWorker,
          :queue => adapter_options[:queue],
          :retry => adapter_options[:retry]
        )

      subject
    end
  end
end
