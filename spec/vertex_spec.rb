require 'awesome_print'

require './vertex'

describe Vertex do
  let(:v1) { described_class.new(0.0, 1.0) }
  let(:v2) { described_class.new(0.0, 1.0) }
  let(:v3) { described_class.new(1.0, 1.0) }

  describe '.==' do

    it 'should work' do
      (v1 == v2).should be_true
      (v1 == v3).should be_false
    end
  end

end

