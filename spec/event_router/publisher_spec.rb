RSpec.describe EventRouter::Publisher do
  describe '.publish' do
    class DummyEvent < EventRouter::Event
      deliver_to :dummy_handler_1, handler: nil
      deliver_to :dummy_handler_2, handler: nil, prefetch_payload: true

      def dummy_handler_2_payload
        { id: 'test' }
      end
    end

    let(:event) { DummyEvent.new }

    EventRouter::Publisher::ADAPTERS.each do |adapter, adapter_class|
      context "when adapter is set to #{adapter}" do
        subject { described_class.publish(event, adapter: adapter) }

        it 'delivers the event to every defined destination' do
          expect(adapter_class).to receive(:deliver).once.with(:dummy_handler_1, event, nil)
          expect(adapter_class).to receive(:deliver).once.with(:dummy_handler_2, event, { id: 'test' })

          subject
        end
      end
    end
  end

  describe '.delivery_adapter_class' do
    EventRouter::Publisher::ADAPTERS.each do |adapter, adapter_class|
      context "when adapter is #{adapter}" do
        subject { described_class.delivery_adapter_class(adapter) }

        it { expect(subject).to eq(adapter_class) }
      end
    end
  end
end
