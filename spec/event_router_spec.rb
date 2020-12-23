RSpec.describe EventRouter do
  it 'has a version number' do
    expect(EventRouter::VERSION).not_to be nil
  end

  describe '.configuration' do
    it { expect(EventRouter.configuration).to be_instance_of(EventRouter::Configuration) }
  end

  describe '.configure' do
    it 'yields the configuration' do
      expect { |b| EventRouter.configure(&b) }.to yield_with_args(EventRouter.configuration)
    end

    it 'memoizes the configurations' do
      expect do
        EventRouter.configure { |c| c.delivery_adapter = :sidekiq }
      end.to change { EventRouter.configuration.delivery_adapter }.to(:sidekiq)
    end
  end
end
