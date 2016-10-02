class Plateau
  attr_reader :max_x, :max_y, :min_x, :min_y
  
  def initialize(max_x, max_y)
    raise ArgumentError.new('Max X and Y must be greater than zero') unless max_x > 0 && max_y > 0
    @min_x, @min_y = 0, 0
    @max_x, @max_y = max_x, max_y
  end

  def valid_position?(x,y)
    x >= min_x && x <= max_x && y >= min_y && y <= max_y
  end
end