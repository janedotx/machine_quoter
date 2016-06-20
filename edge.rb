class Edge
  attr_reader :center, :vertices, :clockwise_vertex
  attr_accessor :next
  attr_accessor :concave

  def initialize(edge_hash)
    @circular = edge_hash['Type'] == 'CircularArc'
    # all id keys will be strings
    @vertices = edge_hash['Vertices'].map { |x| x.to_s }
    if edge_hash['Type'] == 'CircularArc'
      @clockwise_vertex = edge_hash['ClockwiseFrom'].to_s
      @center = edge_hash['Center']
    end
  end

  def circular
    !@center.nil?
  end

  def straight_length
    p1 = vertices[0]
    p2 = vertices[1]
    Math.sqrt((p2.x - p1.x)**2 + (p2.y - p1.y)**2)
  end

  def length
    @length ||= if @circular
        arc_length
      else
        straight_length
      end
  end

  def get_other_vertex(v_id)
    (vertices - [v_id])[0]
  end
end
