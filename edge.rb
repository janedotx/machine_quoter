class Edge
  PI = 3.14159
  attr_reader :center, :vertices, :clockwise_vertex_id, :length, :radius
  attr_accessor :next
  attr_accessor :concave, :convex
  attr_reader :positive_x, :negative_x, :positive_y, :negative_y

  class << self
    def get_dot_product(v1, v2)
      v1.x * v2.x + v1.y * v2.y
    end
  end

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

  def set_radius(vertices_hash)
    v_id = vertices.first
    @radius = get_distance(vertices_hash[v_id], center)
  end

  def translate_edge(vertices_hash)
    v1 = vertices_hash[vertices[0]]
    v2 = vertices_hash[vertices[1]]
    translated_v1 = Vertex.new(v1.x - center.x, v1.y - center.y)
    translated_v2 = Vertex.new(v2.x - center.x, v2.y - center.y)
    [translated_v1, translated_v2]
  end

  # Return angle in radians.
  def get_angle(vertices_hash)
    t_v1, t_v2 = translate_edge(vertices_hash)
    dot_product = self.class.get_dot_product(t_v1, t_v2)
    origin = Vertex.new(0,0)
    magnitude_t_v1 = get_distance(origin, t_v1)
    magnitude_t_v2 = get_distance(origin, t_v2)
    cosine = dot_product / (magnitude_t_v1 * magnitude_t_v2)
    Math.acos(cosine)
  end

  def find_farthest_points(vertices_hash)
    @positive_x = center.x + radius
    @positive_y = center.y + radius
    # In case the convexity is pointing down the negative direction of the x or y axis.
    @negative_x = center.x - radius
    @negative_y = center.y - radius
  end

  def get_distance(p1, p2)
    Math.sqrt((p2.x - p1.x)**2 + (p2.y - p1.y)**2)
  end

  def find_arc_length(vertices_hash)
    set_radius(vertices_hash) unless @radius
    puts 'radius'
    puts @radius
    circumference = 2 *PI * @radius
    angle = get_angle(vertices_hash)
    circumference * (angle / (2 * PI))
  end

  def find_length(vertices_hash)
    @length ||= if circular
        find_arc_length(vertices_hash)
      else
        get_distance(vertices_hash[vertices[0]], vertices_hash[vertices[1]])
      end
  end

  def get_other_vertex(v_id)
    (vertices - [v_id])[0]
  end
end
