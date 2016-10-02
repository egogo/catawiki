class Operator
  attr_reader :plateau, :rovers, :rover_missions

  def initialize
    @rovers, @rover_missions = [], []
  end

  def load_directions!(file_path)
    lines = File.read(file_path).split("\n").reject(&:empty?)

    @plateau = plateau_from_str(lines.shift)
    while (info = lines.shift(2)) && info.size > 0
      rover_info, mission_brief = info
      add_rover(rover_from_info(plateau, rover_info), mission_brief) if rover_info
    end
  end

  def run_mission!
    rover_missions.each_with_index do |dir, idx|
      rovers[idx].apply_commands_from(dir)
    end
  end

  def rover_status_report
    rovers.map {|r| r.report }.join("\n")
  end

  private

  def plateau_from_str(str)
    size = str.split(/\s/).map(&:to_i)
    Plateau.new(*size) if size.size == 2
  end

  def rover_from_info(plateau, position)
    str_x, str_y, facing = position.split(/\s/)
    rover = Rover.new(plateau, str_x.to_i, str_y.to_i, facing)
    rover
  end

  def add_rover(rover, mission_brief)
    @rovers << rover
    @rover_missions << mission_brief
  end
end