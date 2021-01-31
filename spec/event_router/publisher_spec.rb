RSpec.describe EventRouter::Publisher do
  describe 'ADAPTERS' do
    it { expect(described_class::ADAPTERS).to include(:sync, :sidekiq) }

    it 'defines sync attributes' do
      expect(described_class::ADAPTERS[:sync]).to eq(
        adapter_class: 'EventRouter::DeliveryAdapters::Sync',
        path: 'delivery_adapters/sync'
      )
    end

    it 'defines sidekiq attributes' do
      expect(described_class::ADAPTERS[:sidekiq]).to eq(
        adapter_class: 'EventRouter::DeliveryAdapters::Sidekiq',
        path: 'delivery_adapters/sidekiq'
      )
    end
  end

  describe '.publish' do
    subject { described_class.publish([event, event], adapter: :test_adapter) }

    let(:event) { DummyEvent.new }

    before do
      allow(EventRouter.configuration).to receive(:delivery_adapter_class) { DummyDeliveryAdapter }
    end

    it 'delivers the event to the adapter' do
      expect(EventRouter.configuration).to receive(:delivery_adapter_class).once.with(:test_adapter)
      expect(DummyDeliveryAdapter).to receive(:deliver).twice.with(event)

      subject
    end
  end

  describe '.publish_async' do
    subject { described_class.publish_async([event, event], adapter: :test_adapter) }

    let(:event) { DummyEvent.new }

    before do
      allow(EventRouter.configuration).to receive(:delivery_adapter_class) { DummyDeliveryAdapter }
    end

    it 'delivers the event to the adapter' do
      expect(EventRouter.configuration).to receive(:delivery_adapter_class).once.with(:test_adapter)
      expect(DummyDeliveryAdapter).to receive(:deliver_async).twice.with(event)

      subject
    end
  end
end
