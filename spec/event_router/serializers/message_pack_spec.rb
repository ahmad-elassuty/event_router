RSpec.describe EventRouter::Serializers::MessagePack do
  let(:input)   { { sym_key: 1, 'str_key' => 'b', 'bool' => true, c: { a: 1 } } }
  let(:output)  { "\x85\xA7sym_key\x01\xA7str_key\xA1b\xA4bool\xC3\xA1c\x81\xA1a\x01\xA9_er_klass\xA4Hash" }

  describe '.serialize' do
    subject { described_class.serialize(input) }

    it { is_expected.to eq(output) }
  end

  describe '.deserialize' do
    subject { described_class.deserialize(output) }

    it { is_expected.to eq(input) }
  end
end
