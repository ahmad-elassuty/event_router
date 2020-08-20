RSpec.describe EventRouter::Configuration do
  subject(:config) { described_class.new }

  describe '.new' do
    it 'initializes with memory delivery adapter by default' do
      expect(subject.delivery_adapter).to eq(:memory)
    end

    it 'initializes with async delivery strategy by default' do
      expect(subject.delivery_strategy).to eq(:async)
    end
  end

  describe '#delivery_adapter=' do
    EventRouter::Configuration::DELIVERY_ADAPTERS.each do |adapter|
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

  describe '#delivery_strategy=' do
    EventRouter::Configuration::DELIVERY_STRATEGIES.each do |strategy|
      it "supports #{strategy} strategy" do
        expect { config.delivery_strategy = strategy }.to_not raise_error
      end

      it "updates the configuration to #{strategy}" do
        config.delivery_strategy = strategy

        expect(config.delivery_strategy).to eq(strategy)
      end
    end

    context 'when given unsupported option' do
      it 'raises unsupported option error' do
        expect { config.delivery_strategy = :invalid }.to raise_error(EventRouter::Errors::UnsupportedOptionError)
      end
    end
  end
end
