class Vertex
  attr_accessor :x, :y
  def initialize(x, y)
    @x = x.to_f
    @y = y.to_f
  end

  def to_s
    "X: #{@x}, Y: #{@y}"
  end

  def ==(other_vertex)
    @x == other_vertex.x && @y == other_vertex.y
  end
end
