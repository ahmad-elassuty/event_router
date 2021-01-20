require 'event_router/delivery_adapters/sidekiq'

RSpec.describe EventRouter::DeliveryAdapters::Sidekiq do
  describe '.deliver' do
    subject { described_class.deliver(event) }

    let(:event)                           { DummyEvent.new }
    let(:serialized_event)                { EventRouter.serialize(event) }
    let(:adapter_options)                 { { queue: :default, retry: 1 } }
    let(:enabled_prefetch_destinations)   { event.destinations.select { |_k, v| v.prefetch_payload? } }
    let(:disabled_prefetch_destinations)  { event.destinations.reject { |_k, v| v.prefetch_payload? } }

    before do
      allow(described_class).to receive(:options) { adapter_options }
    end

    it 'schedules one worker per destination' do
      enabled_prefetch_destinations.each do |name, destination|
        serialized_payload = EventRouter.serialize(destination.extra_payload(event))

        expect(EventRouter::DeliveryAdapters::Jobs::SidekiqEventDeliveryJob).to receive(:client_push)
          .with(
            'args' => [name, serialized_event, serialized_payload],
            'class' => EventRouter::DeliveryAdapters::Jobs::SidekiqEventDeliveryJob,
            :queue => adapter_options[:queue],
            :retry => adapter_options[:retry]
          )
      end

      disabled_prefetch_destinations.each do |name, _destination|
        expect(EventRouter::DeliveryAdapters::Jobs::SidekiqEventDeliveryJob).to receive(:client_push)
          .with(
            'args' => [name, serialized_event, nil],
            'class' => EventRouter::DeliveryAdapters::Jobs::SidekiqEventDeliveryJob,
            :queue => adapter_options[:queue],
            :retry => adapter_options[:retry]
          )
      end

      subject
    end
  end
end
