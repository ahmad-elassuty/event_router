require 'event_router/serializers/oj'

RSpec.describe EventRouter::Serializers::Oj do
  let(:input)   { { sym_key: 1, 'str_key' => 'b', 'bool' => true, c: { a: 1 } } }
  let(:output)  { '{":sym_key":1,"str_key":"b","bool":true,":c":{":a":1}}' }

  describe '.serialize' do
    subject { described_class.serialize(input) }

    it { is_expected.to eq(output) }
  end

  describe '.deserialize' do
    subject { described_class.deserialize(output) }

    it { is_expected.to eq(input) }
  end
end
