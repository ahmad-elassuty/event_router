RSpec.describe EventRouter::Serializer do
  describe 'ADAPTERS' do
    it { expect(described_class::ADAPTERS).to include(:json, :oj) }

    it 'defines json attributes' do
      expect(described_class::ADAPTERS[:json]).to eq(
        adapter_class: 'EventRouter::Serializers::Json',
        path: 'serializers/json'
      )
    end

    it 'defines oj attributes' do
      expect(described_class::ADAPTERS[:oj]).to eq(
        adapter_class: 'EventRouter::Serializers::Oj',
        path: 'serializers/oj'
      )
    end
  end

  describe '.serialize' do
    subject { described_class.serialize(event, adapter: :test_adapter) }

    let(:event) { DummyEvent.new }

    before do
      allow(EventRouter.configuration).to receive(:serializer_adapter_class) { DummySerializerAdapter }
    end

    it 'delegates the event to the adapter' do
      expect(EventRouter.configuration).to receive(:serializer_adapter_class).once.with(:test_adapter)
      expect(DummySerializerAdapter).to receive(:serialize).once.with(event)

      subject
    end
  end

  describe '.deserialize' do
    subject { described_class.deserialize(payload, adapter: :test_adapter) }

    let(:payload) { {a: 1}.to_json }

    before do
      allow(EventRouter.configuration).to receive(:serializer_adapter_class) { DummySerializerAdapter }
    end

    it 'delegates the event with the adapter' do
      expect(EventRouter.configuration).to receive(:serializer_adapter_class).once.with(:test_adapter)
      expect(DummySerializerAdapter).to receive(:deserialize).once.with(payload)

      subject
    end
  end
end
