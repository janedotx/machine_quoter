class Vertex
  attr_accessor :x, :y
  def initialize(x, y)
    @x = x
    @y = y
  end

  def to_s
    "X: #{@x}, Y: #{@y}"
  end
end
