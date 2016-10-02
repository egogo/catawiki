require File.expand_path '../../test_helper.rb', __FILE__

describe Rover do
  let(:described_class) { Rover }
  let(:plateau) { Plateau.new(5, 5) }
  let(:rover) { described_class.new(plateau, 0, 0, 'N') }

  describe 'initialization' do
    let(:plateau) { Plateau.new(5, 5) }
    let(:start_x) { 0 }
    let(:start_y) { 2 }
    let(:start_direction) { 'N' }

    describe 'when initial coordinates are valid' do
      it 'sets initialization variables' do
        instance = described_class.new(plateau, start_x, start_y, start_direction)
        instance.plateau.must_equal plateau
        instance.x.must_equal start_x
        instance.y.must_equal start_y
        instance.direction.must_equal start_direction
      end
    end

    describe 'when plateau is invalid' do
      it 'raises an error' do
        err = -> { described_class.new(nil, start_x, start_y, start_direction) }.must_raise ArgumentError
        err.message.must_equal "plateau must be a valid instance of Plateau"
      end
    end

    describe 'when initial coordinates are invalid' do
      it 'raises an error when initialized with "out of plateau" coords' do
        err = -> { described_class.new(plateau, start_x, 15, start_direction) }.must_raise ArgumentError
        err.message.must_equal 'Initial coordinates are out of plateau area'
      end

      it 'raises an error when initialized with invalid direction' do
        err = -> { described_class.new(plateau, 3, 2, 'Z') }.must_raise ArgumentError
        err.message.must_equal 'Initial direction is invalid, possible values are: N S E W'
      end
    end
  end

  describe '#apply_command' do
    describe 'when command is valid' do
      describe 'when it is L command' do
        before { rover.expects(:change_direction!).with('L') }

        it 'calls #change_direction! with "L"' do
          rover.apply_command('L')
        end
      end

      describe 'when it is R command' do
        before { rover.expects(:change_direction!).with('R') }

        it 'calls #change_direction! with "R"' do
          rover.apply_command('R')
        end
      end

      describe 'when it is M command' do
        before { rover.expects(:calculate_new_location!) }

        it 'calls #calculate_new_location!' do
          rover.apply_command('M')
        end
      end
    end

    describe 'when command is invalid' do
      it 'raises an error' do
        err = -> { rover.apply_command('Z') }.must_raise ArgumentError
        err.message.must_equal "'Z' is not a valid command, use: L, R, M"
      end
    end
  end

  describe '#apply_commands_from' do
    let(:cmd_str) { 'LMR' }

    before do
      rover.expects(:apply_command).with('L')
      rover.expects(:apply_command).with('M')
      rover.expects(:apply_command).with('R')
    end

    it 'passes each character of the string passed to #apply_command' do
      rover.apply_commands_from(cmd_str)
    end
  end

  describe '#report' do
    it 'returns its current position summary' do
      rover.report.must_equal "Position: 0, 0, facing: N"
      rover.apply_commands_from('MMRMRRL')
      rover.report.must_equal "Position: 1, 2, facing: S"
    end
  end

  it 'itegration' do
    instanceA = described_class.new(plateau, 1, 2, 'N')
    instanceA.apply_commands_from('LMLMLMLMM')
    instanceA.x.must_equal 1
    instanceA.y.must_equal 3
    instanceA.direction.must_equal 'N'
    instanceA.report.must_equal 'Position: 1, 3, facing: N'


    instanceB = described_class.new(plateau, 3, 3, 'E')
    instanceB.apply_commands_from('MMRMMRMRRM')
    instanceB.x.must_equal 5
    instanceB.y.must_equal 1
    instanceB.direction.must_equal 'E'
    instanceB.report.must_equal 'Position: 5, 1, facing: E'
  end
end