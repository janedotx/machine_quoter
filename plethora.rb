require 'json'
require './vertex'
require './edge'

class Shape
  V_MAX = 0.5
  MATERIAL_COST = 0.75
  TIME_COST = 0.07
  KERF_PADDING = 0.1

  attr_reader :edges
  attr_reader :vertices

  def initialize(file)
    @schema = JSON.parse(File.read(file))
    @vertices = get_vertices
    @edges = get_edges
  end

  def find_edge_by_vertices(v1, v2)
    @edges.each_pair do |id, edge|
      return id if edge.vertices.include?(v1) && edge.vertices.include?(v2)
    end
    nil
  end

  def find_edges_by_vertex(v_id)
    edges = []
    @edges.each_pair do |id, edge|
      edges << id if edge.vertices.include?(v_id)
    end
    return edges
  end

  # Create a hash where the keys are the ids and the values are Edge instances.
  def get_edges
    edges = {}
    @schema['Edges'].each do |raw_edge|
      id = raw_edge[0].to_s
      edges[id] = Edge.new(raw_edge[1])
    end
    edges
  end

  def get_vertices
    vertices = {}
    @schema['Vertices'].each do |raw_vertex|
      id = raw_vertex[0].to_s
      coordinates = raw_vertex[1]['Position']
      vertices[id] = Vertex.new(coordinates['X'].to_f, coordinates['Y'].to_f)
    end
    vertices
  end

  # todo make comment on cleanup
  def find_origin
    @vertices.each_pair do |id, vertex|
      return id if vertex.x == 0.0 && vertex.y == 0.0
    end
    raise 'no origin point'
  end

  # @param [String] v_id vertex id
  # @return [Array<String>] ids of neighboring vertices
  def get_neighboring_vertices(v_id)
    edges = find_edges_by_vertex(v_id)
    neighbor_1 = (@edges[edges[0]].vertices - [v_id])[0]
    neighbor_2 = (@edges[edges[1]].vertices - [v_id])[0]
    [neighbor_1, neighbor_2]
  end

  def get_other_edge(v_id, edge_id)
    (find_edges_by_vertex(v_id) - [edge_id])[0]
  end

  def process_edges
    # Assume that one point will always be at the origin. The points can always be translated in such a way that this is true,
    # so it's a reasonable simplifying assumption.
    @origin = find_origin
    next_vertex_id = get_clockwise_neighbor(*get_neighboring_vertices(@origin))
    current_edge_id = find_edge_by_vertices(@origin, next_vertex_id)

    # Set the current vertex to be the leading vertex of the current edge we're on.
    current_vertex_id = next_vertex_id
    current_edge = @edges[current_edge_id]
    @first_edge_id = current_edge_id

    (@edges.size - 1).times do
      next_edge_id = get_other_edge(current_vertex_id, current_edge_id)
      next_edge = @edges[next_edge_id]

      # We are advancing clockwise. If a curve is anti-clockwise, then the curve is concave. Intuitively, a concave angle is
      # created when the path 'reverses direction.'
      if next_edge.circular
        next_edge.set_radius(@vertices)

        if current_vertex_id == next_edge.clockwise_vertex_id
          next_edge.concave = false
          next_edge.find_farthest_points(@vertices)
        else
          next_edge.concave = true
        end
      end

      current_edge_id = next_edge_id
      current_edge = @edges[current_edge_id]
      current_vertex_id = current_edge.get_other_vertex(current_vertex_id)
    end
  end

  # Obviously this doesn't come close to covering all the kinds of shapes that could be requisitioned. I went with this because
  # it vaguely captures the idea that to move clockwise, you have to move 'up' and 'left' of the side of the clock, and it works
  # well enough if you know you're starting at the origin.
  def get_clockwise_neighbor(id_1, id_2)
    return id_1 if @vertices[id_1].y > @vertices[id_2].y
    return id_1 if @vertices[id_1].x < @vertices[id_2].x
    return id_2
  end

  def get_bounding_box_dimensions
    min_x = 0.0
    min_y = 0

    max_x = 0
    max_y = 0

    @edges.each_pair do |id, edge|
      x_coords = []
      y_coords = []
      vertices = edge.vertices.map { |v| @vertices[v] }

      vertices.each do |v|
        x_coords << v.x
        y_coords << v.y
      end
      puts edge.inspect
      if edge.convex
        x_coords << edge.negative_x
        x_coords << edge.positive_x
        y_coords << edge.negative_y
        y_coords << edge.positive_y
      end

      if x_coords.min < min_x
        min_x = x_coords.min
      end
      if x_coords.max > max_x
        max_x = x_coords.max
      end

      if y_coords.min < min_y
        min_y = y_coords.min
      end
      if y_coords.max > max_y
        max_y = y_coords.max
      end
    end
    [max_x - min_x, max_y - min_y]
  end

  def get_materials_cost
    x, y = get_bounding_box_dimensions
    (x + KERF_PADDING) * (y + KERF_PADDING) * MATERIAL_COST
  end

  def arc_laser_speed(radius)
    V_MAX * (Math.exp(-1/radius))
  end

  def get_laser_cutting_cost
    cost = 0.0
    @edges.each_value do |edge|
      edge.find_length(@vertices)
      if edge.circular
        cost += (edge.length / arc_laser_speed(edge.radius)) * TIME_COST
      else
        cost += (edge.length / V_MAX) * TIME_COST
      end
    end
    cost
  end

  def get_total_costs
    process_edges
    (get_materials_cost + get_laser_cutting_cost).round(2)
  end
end
