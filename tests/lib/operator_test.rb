require File.expand_path '../../test_helper.rb', __FILE__

describe Operator do
  let(:described_class) { Operator }
  let(:directions_file_path) { File.expand_path('../directions.txt', __FILE__) }
  let(:instance) { described_class.new }

  describe '#load_directions!' do
    it 'reads directions file and intializes plateau and rovers with missions' do
      instance.plateau.must_equal nil
      instance.rovers.must_equal []
      instance.rover_missions.must_equal []

      instance.load_directions!(directions_file_path)

      instance.plateau.must_be_instance_of Plateau
      instance.plateau.max_x.must_equal 5
      instance.plateau.max_x.must_equal 5

      first_rover = instance.rovers.first
      first_rover.x.must_equal 1
      first_rover.y.must_equal 2
      first_rover.direction.must_equal 'N'

      first_rover_mission = instance.rover_missions.first
      first_rover_mission.must_equal 'LMLMLMLMM'

      second_rover = instance.rovers.last
      second_rover.x.must_equal 3
      second_rover.y.must_equal 3
      second_rover.direction.must_equal 'E'

      second_rover_mission = instance.rover_missions.last
      second_rover_mission.must_equal 'MMRMMRMRRM'
    end
  end

  describe '#run_mission!' do
    let(:rover_a) { mock }
    let(:rover_b) { mock }
    let(:mission_a) { 'RRML' }
    let(:mission_b) { 'RRMMR' }

    before do
      instance.instance_variable_set(:@rovers, [rover_a, rover_b])
      instance.instance_variable_set(:@rover_missions, [mission_a, mission_b])

      rover_a.expects(:apply_commands_from).with(mission_a)
      rover_b.expects(:apply_commands_from).with(mission_b)
    end

    it 'calls #apply_commands_from with a mission statement on each rover' do
      instance.run_mission!
    end
  end

  describe '#rover_status_report' do
    describe 'when no rovers' do
      it 'returns an empty string' do
        instance.rover_status_report.must_equal ''
      end
    end

    describe 'with some rovers' do
      let(:rover_a) { mock }
      let(:rover_b) { mock }

      before do
        instance.instance_variable_set(:@rovers, [rover_a, rover_b])
        rover_a.expects(:report).returns('Rover A report')
        rover_b.expects(:report).returns('Rover B report')
      end

      it 'returns a rover status per line' do
        instance.rover_status_report.must_equal "Rover A report\nRover B report"
      end
    end
  end

  it 'runs the mission from file' do
    operator = described_class.new
    operator.load_directions!(directions_file_path)
    operator.rover_status_report.must_equal "Position: 1, 2, facing: N\nPosition: 3, 3, facing: E"
    operator.run_mission!
    operator.rover_status_report.must_equal "Position: 1, 3, facing: N\nPosition: 5, 1, facing: E"
  end

end