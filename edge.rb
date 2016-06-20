class Edge
  attr_reader :center, :vertices, :clockwise_vertex_id, :length, :radius
  attr_accessor :next
  attr_accessor :concave
  attr_reader :positive_x, :negative_x, :positive_y, :negative_y

  def initialize(edge_hash)
    # All id keys will be strings
    @vertices = edge_hash['Vertices'].map { |x| x.to_s }
    if edge_hash['Type'] == 'CircularArc'
      @clockwise_vertex_id = edge_hash['ClockwiseFrom'].to_s
      @center = Vertex.new(edge_hash['Center']['X'], edge_hash['Center']['Y'])
    end
  end

  def circular
    !@center.nil?
  end

  def convex
    center && !concave 
  end

  def set_radius(vertices_hash)
    v_id = vertices.first
    @radius = get_distance(vertices_hash[v_id], center)
  end

  def find_farthest_points(vertices_hash)
    @positive_x = center.x + radius
    @positive_y = center.y + radius
    @negative_x = center.x - radius
    @negative_y = center.y - radius
  end

  def get_distance(p1, p2)
    Math.sqrt((p2.x - p1.x)**2 + (p2.y - p1.y)**2)
  end

  def find_arc_length
    raise 'no radius yet' unless @radius
    3.14159 * @radius
  end

  def find_length(vertices_hash)
    @length ||= if @center
        find_arc_length
      else
        get_distance(vertices_hash[vertices[0]], vertices_hash[vertices[1]])
      end
  end

  def get_other_vertex(v_id)
    (vertices - [v_id])[0]
  end
end
