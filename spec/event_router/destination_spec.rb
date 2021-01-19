RSpec.describe EventRouter::Destination do
  describe '#process' do
    subject { destination.process(event, payload) }

    let(:event)       { DummyEvent.new }
    let(:payload)     { nil }

    context 'when handler_method is not defined' do
      let(:destination) { described_class.new(:test, handler: DummyHandler) }

      it 'calls a handler with the same event name' do
        expect(DummyHandler).to receive(:dummy_event).once.with(event: event, payload: payload)

        subject
      end
    end

    context 'with custom handler method' do
      let(:destination) { described_class.new(:test, handler: DummyHandler, handler_method: :custom_handler) }

      it 'calls a custom handler method' do
        expect(DummyHandler).to receive(:custom_handler).once.with(event: event, payload: payload)

        subject
      end
    end
  end

  describe '#prefetch_payload?' do
    subject { destination.prefetch_payload? }

    let(:destination) { described_class.new(:test, handler: DummyHandler, prefetch_payload: enabled) }

    context 'when prefetch enabled' do
      let(:enabled) { true }

      it { is_expected.to be_truthy }
    end

    context 'when prefetch disabled' do
      let(:enabled) { false }

      it { is_expected.to be_falsey }
    end
  end

  describe '#extra_payload' do
    subject { destination.extra_payload(event) }

    let(:event) { DummyEvent.new }

    context 'when custom payload method is not set' do
      let(:destination) { described_class.new(:test, handler: DummyHandler) }

      context 'and there is payload method with destination name' do
        let(:payload) { { id: 1 } }

        before { allow(event).to receive(:test_payload) { payload } }

        it { is_expected.to eq(payload) }
      end

      context 'and there is not payload method with destination name' do
        it { is_expected.to eq(nil) }
      end
    end

    context 'when custom payload method is set' do
      let(:destination) { described_class.new(:test, handler: DummyHandler, payload_method: :custom_payload_method) }

      context 'and event implements the payload method' do
        let(:payload) { { id: 1 } }

        before { allow(event).to receive(:custom_payload_method) { payload } }

        it { is_expected.to eq(payload) }
      end

      context 'and event does not implement the payload method' do
        it { is_expected.to eq(nil) }
      end
    end
  end
end
