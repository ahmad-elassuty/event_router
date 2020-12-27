RSpec.describe EventRouter::Serializers::Json do
  describe '.serialize' do
    subject { described_class.serialize(input) }

    let(:input)           { { sym_key: 1, 'str_key' => 'b', 'bool' => true, c: { a: 1 } } }
    let(:expected_output) { '{"sym_key":1,"str_key":"b","bool":true,"c":{"a":1},"event_class":"Hash"}' }

    it { is_expected.to eq(expected_output) }
  end

  xdescribe '.deserialize' do
    subject { described_class.deserialize(input) }

    context "event_class is not defined" do
      let(:input) { '{"sym_key":1,"str_key":"b","bool":true,"c":{"a":1},"event_class":"Hash"}' }
      let(:expected_output) { { 'sym_key' => 1, 'str_key' => 'b', 'bool' => true, 'c' => { 'a' => 1 } } }

      it { is_expected.to eq(expected_output) }
    end
  end
end
