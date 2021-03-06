require 'event_router/serializers/json'

RSpec.describe EventRouter::Serializers::Json do
  let(:input)   { { sym_key: 1, 'str_key' => 'b', 'bool' => true, c: { a: 1 } } }
  let(:output)  { '{"sym_key":1,"str_key":"b","bool":true,"c":{"a":1}}' }

  describe '.serialize' do
    subject { described_class.serialize(input) }

    it { is_expected.to eq(output) }
  end

  describe '.deserialize' do
    subject { described_class.deserialize(output) }

    let(:input) { { 'sym_key' => 1, 'str_key' => 'b', 'bool' => true, 'c' => { 'a' => 1 } } }

    it { is_expected.to eq(input) }
  end
end
