RSpec.describe EventRouter do
  it 'has a version number' do
    expect(EventRouter::VERSION).not_to be nil
  end

  describe '.publish' do
    subject { EventRouter.publish(event) }

    let(:event) { DummyEvent.new }

    it 'delegates to publisher' do
      expect(EventRouter::Publisher).to receive(:publish).once.with(event, adapter: :sync)
      subject
    end
  end

  describe '.serialize' do
    subject { EventRouter.serialize(event) }

    let(:event) { DummyEvent.new }

    it 'delegates to serializer' do
      expect(EventRouter::Serializer).to receive(:serialize).once.with(event, adapter: :json)
      subject
    end
  end

  describe '.deserialize' do
    subject { EventRouter.deserialize(payload) }

    let(:payload) { { a: 1 }.to_json }

    it 'delegates to serializer' do
      expect(EventRouter::Serializer).to receive(:deserialize).once.with(payload, adapter: :json)
      subject
    end
  end

  describe '.configuration' do
    it { expect(EventRouter.configuration).to be_instance_of(EventRouter::Configuration) }
  end

  describe '.configure' do
    it 'yields the configuration' do
      expect { |b| EventRouter.configure(&b) }.to yield_with_args(EventRouter.configuration)
    end
  end
end
