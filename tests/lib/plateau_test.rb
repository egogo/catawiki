require File.expand_path '../../test_helper.rb', __FILE__

describe Plateau do
  let(:described_class) { Plateau }


  describe 'initialization' do

    describe 'for coords, that will create zero-size plateau' do
      it 'raises an error' do
        err = -> { described_class.new(0,0) }.must_raise ArgumentError
        err.message.must_equal "Max X and Y must be greater than zero"
      end
    end

    describe 'for coords, that will create zero-width plateau' do
      it 'raises an error' do
        err = -> { described_class.new(0,4) }.must_raise ArgumentError
        err.message.must_equal "Max X and Y must be greater than zero"
      end
    end

    describe 'for coords, that will create zero-height plateau' do
      it 'raises an error' do
        err = -> { described_class.new(3,0) }.must_raise ArgumentError
        err.message.must_equal "Max X and Y must be greater than zero"
      end
    end

    describe 'for coords, that will create >=1 x >=1 plateau' do
      it 'sets plateau size' do
        instance = described_class.new(8,4)

        instance.min_x.must_equal 0
        instance.min_y.must_equal 0

        instance.max_x.must_equal 8
        instance.max_y.must_equal 4
      end
    end
  end

  describe '#valid_position?' do
    let(:instance) { described_class.new(5,5) }

    describe 'when within plateau bounds' do
      it 'returns true' do
        instance.valid_position?(0,0).must_equal true
        instance.valid_position?(3,3).must_equal true
        instance.valid_position?(5,5).must_equal true
      end
    end

    describe 'when out of plateau bounds' do
      it 'returns false' do
        instance.valid_position?(-1,0).must_equal false
        instance.valid_position?(0,-1).must_equal false
        instance.valid_position?(5,6).must_equal false
        instance.valid_position?(6,5).must_equal false
        instance.valid_position?(-1,-1).must_equal false
        instance.valid_position?(6,6).must_equal false
      end
    end
  end

end