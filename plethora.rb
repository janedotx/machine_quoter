require 'json'
require './vertex'
require './edge'

class Shape
  V_MAX = 0.5
  MATERIAL_COST = 0.75
  TIME_COST = 0.07

  attr_reader :schema
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

  def connect_edges
    # Assume that one point will always be at the origin. The points can always be translated in such a way that this is true,
    # so it's a reasonable simplifying assumption.
    @origin = find_origin
    next_vertex_id = get_clockwise_neighbor(*get_neighboring_vertices(@origin))
    current_edge_id = find_edge_by_vertices(@origin, next_vertex_id)

    # Set the current vertex to be the leading vertex of the current edge we're on.
    current_vertex_id = next_vertex_id
    current_edge = @edges[current_edge_id]
    @first_edge_id = current_edge_id

    # Get the next edge and next vertex, linking the current edge to the next edge as we advance clockwise.
    (@edges.size - 1).times do
      next_edge_id = get_other_edge(current_vertex_id, current_edge_id)
      next_edge = @edges[next_edge_id]

      if next_edge.circular

=begin
      puts 'circle time'
        puts "current edge " + current_edge_id.to_s
        puts 'cur edge point 1'
        puts vertices[current_edge.vertices[0]]
        puts 'cur edge point 2'
        puts vertices[current_edge.vertices[1]]
      puts 'current vertex ' + current_vertex_id
      puts @vertices[current_vertex_id]
      puts "next edge id: #{next_edge_id}"
      puts "clockwise: #{next_edge.clockwise_vertex_id}"
      puts 'current edge get oter vertex ' + current_edge.get_other_vertex(current_vertex_id).to_s
        ap vertices
        puts 'at circular edge'
=end
        if current_vertex_id == next_edge.clockwise_vertex_id
          next_edge.concave = false
          next_edge.find_farthest_points(@vertices)
        else
          next_edge.concave = true
        end
      end

      current_edge.next = next_edge_id
      current_edge_id = next_edge_id
      current_edge = @edges[current_edge_id]
      current_vertex_id = current_edge.get_other_vertex(current_vertex_id)
    end

    # close the loop
    current_edge.next = @first_edge_id
  end

  # putting in the simplifying assumption
  def get_clockwise_neighbor(id_1, id_2)
    return id_1 if @vertices[id_1].x < 0
    return id_2 if @vertices[id_2].x < 0
    return id_1 if @vertices[id_1].x == 0 && @vertices[id_1].y > 0
    return id_2 if @vertices[id_2].x == 0 && @vertices[id_2].y > 0
    raise 'the limitations of the clockwise-finding logic have been reached'
  end

end

def cross_product(v1, v2, v3)
end
# "ap
# "bp
def get_distance_between(p1, p2)
  Math.sqrt((p2.x - p1.x)**2 + (p2.y - p1.y)**2)
end

