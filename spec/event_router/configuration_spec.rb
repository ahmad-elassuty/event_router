RSpec.describe EventRouter::Configuration do
  subject(:config) { described_class.new }

  describe '.new' do
    it 'initializes with memory delivery adapter by default' do
      expect(subject.delivery_adapter).to eq(:sync)
    end
  end

  describe '#delivery_adapter=' do
    EventRouter::Publisher::ADAPTERS.each do |adapter, _adapter_class|
      it "supports #{adapter} adapter" do
        expect { config.delivery_adapter = adapter }.to_not raise_error
      end

      it 'updates the configuration' do
        config.delivery_adapter = adapter

        expect(config.delivery_adapter).to eq(adapter)
      end
    end

    context 'when given unsupported option' do
      it 'raises unsupported option error' do
        expect { config.delivery_adapter = :invalid }.to raise_error(EventRouter::Errors::UnsupportedOptionError)
      end
    end
  end

  describe '#serializer_adapter' do
    context 'by default' do
      it { expect(config.serializer_adapter).to eq(:json) }
    end

    EventRouter::Serializer::ADAPTERS.each do |adapter, _adapter_class|
      it "supports #{adapter} adapter" do
        expect { config.serializer_adapter = adapter }.to_not raise_error
      end

      it "updates the configuration to #{adapter}" do
        config.serializer_adapter = adapter

        expect(config.serializer_adapter).to eq(adapter)
      end
    end

    context 'when adapter is not supported' do
      it 'raises unsupported option error' do
        expect { config.serializer_adapter = :invalid }.to raise_error(EventRouter::Errors::UnsupportedOptionError)
      end
    end
  end
end
