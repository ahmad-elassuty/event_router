RSpec.describe EventRouter::Serializers::Marshal do
  let(:input) { { sym_key: 1, 'str_key' => 'b', 'bool' => true, c: { a: 1 } } }

  let(:output) do
    "\x04\b{\t:\fsym_keyi\x06I\"\fstr_key\x06:\x06ETI\"\x06b" \
    "\x06;\x06TI\"\tbool\x06;\x06TT:\x06c{\x06:\x06ai\x06"
  end

  describe '.serialize' do
    subject { described_class.serialize(input) }

    it { is_expected.to eq(output) }
  end

  describe '.deserialize' do
    subject { described_class.deserialize(output) }

    it { is_expected.to eq(input) }
  end
end
