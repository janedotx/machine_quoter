require 'json'

class Shape
  V_MAX = 0.5
  MATERIAL_COST = 0.75
  TIME_COST = 0.07

  attr_reader :edges
  attr_reader :vertices

  def initialize(file)
    @edges = []
    @vertices = []

    contents_hash = JSON.parse(File.read(file))
    contents_hash['Edges'].to_a.each do |edge_hash|
      @edges << Edge.new(edge_hash)
    end
  end
end

class Edge
  def initialize(edge_hash)
    puts edge_hash.inspect
  end
end

class Vertex
  attr_accessor :x, :y, :id
  def initialize(id, x, y)
    @id = id
    @x = x
    @y = y
  end
end

def cross_product(v1, v2, v3)
  
end
# "ap
# "bp
def get_distance_between(p1, p2)
  Math.sqrt((p2.x - p1.x)**2 + (p2.y - p1.y)**2)
end

