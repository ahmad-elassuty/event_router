RSpec.describe EventRouter::Configuration do
  let(:config) { described_class.new }

  describe '.new' do
    subject { config }

    it 'initializes with sync delivery adapter by default' do
      expect(subject.delivery_adapter).to eq(:sync)
    end

    it 'initializes with json serialization adapter by default' do
      expect(subject.serializer_adapter).to eq(:json)
    end
  end

  describe '#delivery_adapter=' do
    subject { config.delivery_adapter = :test_adapter }

    context 'when adapter is registered' do
      before { config.register_delivery_adapter(:test_adapter, adapter_class: DummyDeliveryAdapter) }

      it 'does not raise error' do
        expect { subject }.to_not raise_error
      end

      it 'updates the default adapter' do
        expect { subject }.to change(config, :delivery_adapter).from(:sync).to(:test_adapter)
      end
    end

    context 'when adapter is not registered' do
      it 'raises unsupported option error' do
        expect { subject }.to raise_error(EventRouter::Errors::UnsupportedOptionError)
      end
    end
  end

  describe '#register_delivery_adapter' do
    subject { config.register_delivery_adapter(:test_adapter, adapter_class: DummyDeliveryAdapter, key: :value) }

    before { subject }

    it 'updates delivery adapters' do
      expect(config.delivery_adapters[:test_adapter]).to eq(DummyDeliveryAdapter)
    end

    it 'sets the adapter options' do
      expect(DummyDeliveryAdapter.options).to include(key: :value)
    end
  end

  describe '#delivery_adapter_class' do
    subject { config.delivery_adapter_class(:test_adapter) }

    before { config.register_delivery_adapter(:test_adapter, adapter_class: DummyDeliveryAdapter) }

    it 'returns the adapter class' do
      expect(subject).to eq(DummyDeliveryAdapter)
    end
  end

  describe '#serializer_adapter=' do
    subject { config.serializer_adapter = :test_adapter }

    context 'when adapter is registered' do
      before { config.register_serializer_adapter(:test_adapter, adapter_class: DummySerializerAdapter) }

      it 'does not raise error' do
        expect { subject }.to_not raise_error
      end

      it 'updates the default adapter' do
        expect { subject }.to change(config, :serializer_adapter).from(:json).to(:test_adapter)
      end
    end

    context 'when adapter is not registered' do
      it 'raises unsupported option error' do
        expect { subject }.to raise_error(EventRouter::Errors::UnsupportedOptionError)
      end
    end
  end

  describe '#register_serializer_adapter' do
    subject { config.register_serializer_adapter(:test_adapter, adapter_class: DummySerializerAdapter, key: :value) }

    before { subject }

    it 'updates serializer adapters' do
      expect(config.serializer_adapters[:test_adapter]).to eq(DummySerializerAdapter)
    end
  end

  describe '#serializer_adapter_class' do
    subject { config.serializer_adapter_class(:test_adapter) }

    before { config.register_serializer_adapter(:test_adapter, adapter_class: DummySerializerAdapter) }

    it 'returns the adapter class' do
      expect(subject).to eq(DummySerializerAdapter)
    end
  end
end
