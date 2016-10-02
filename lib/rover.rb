class Rover
  attr_reader :plateau, :x, :y, :direction

  DIRECTIONS = %w(N E S W).freeze
  COMMANDS = %w(L R M).freeze

  def initialize(plateau, x, y, direction)
    raise ArgumentError.new('plateau must be a valid instance of Plateau') unless plateau.is_a?(Plateau)
    @plateau = plateau
    raise ArgumentError.new('Initial coordinates are out of plateau area') unless plateau.valid_position?(x,y)
    @x, @y = x, y
    raise ArgumentError.new('Initial direction is invalid, possible values are: N S E W') unless DIRECTIONS.include?(direction)
    @direction = direction
  end

  def apply_command(cmd)
    case cmd
      when 'L','R'
        change_direction!(cmd)
      when 'M'
        calculate_new_location!
      else
        raise ArgumentError.new("'#{cmd}' is not a valid command, use: #{COMMANDS.join(', ')}")
    end
  end

  def apply_commands_from(str)
    str.chars.each {|cmd| apply_command(cmd) }
  end

  def report
    "Position: #{x}, #{y}, facing: #{direction}"
  end

  private

  def calculate_new_location!
    new_x, new_y = target_x, target_y
    if location_valid?(new_x, new_y)
      apply_location(new_x, new_y)
    else
      raise ArgumentError.new('New location is invalid.')
    end
  end

  def change_direction!(dir)
    case dir
      when 'L'
        idx = DIRECTIONS.index(direction) - 1
        @direction = DIRECTIONS[(idx < 0 ? DIRECTIONS.size - 1 : idx)]
      when 'R'
        idx = DIRECTIONS.index(direction) + 1
        @direction = DIRECTIONS[(idx >= DIRECTIONS.size ? 0 : idx)]
      else
        raise ArgumentError.new('Invalid direction')
    end
  end

  def target_x
    case direction
      when 'W'
        x - 1
      when 'E'
        x + 1
      else
        x
    end
  end

  def target_y
    case direction
      when 'N'
        y + 1
      when 'S'
        y - 1
      else
        y
    end
  end

  def location_valid?(x, y)
    plateau.valid_position?(x,y)
  end

  def apply_location(x, y)
    @x, @y = x, y
  end


end