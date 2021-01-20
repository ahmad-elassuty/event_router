RSpec.describe EventRouter::Event do
  let(:event) { DummyEvent.new }

  describe '#name' do
    subject { event.name }

    it { is_expected.to eq('dummy_event') }
  end

  describe '#to_hash' do
    subject { event.to_hash }

    it { is_expected.to include(:uid, :correlation_id, :payload, :created_at) }
  end

  describe '.deliver_to' do
    subject { temp_event.deliver_to(:test_destination, handler: DummyHandler) }

    let(:temp_event) { stub_const("#{self.class}::TempEvent", Class.new(EventRouter::Event)) }

    it 'creates a new destination on the class level' do
      expect { subject }.to change { temp_event.destinations.count }.by(1)
    end

    it 'adds the new destination' do
      subject

      expect(temp_event.destinations).to have_key(:test_destination)
    end
  end

  describe '.publish' do
    subject { DummyEvent.publish }

    it 'delegates to EventRouter.publish' do
      expect(EventRouter).to receive(:publish).once.with(instance_of(DummyEvent))

      subject
    end
  end
end
