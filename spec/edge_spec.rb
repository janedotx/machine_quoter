require './edge'
require './vertex'

describe Edge do
  let(:v1) { Vertex.new(0.0, 3.0) }
  let(:v2) { Vertex.new(3.0, 3.0) }
  let(:v3) { Vertex.new(3.0, 0.0) }
  let(:v4) { Vertex.new(2.0, 3.0) }
  let(:v5) { Vertex.new(4.0, 1.0) }

  let(:vertices_hash) { { '1' => v1, '2' => v2, '3' => v3 } }

  let(:straight_edge) { described_class.new(  { 'Type' => 'LineSegment', 'Vertices' => [1, 2]}) }
  let(:arc) do
    described_class.new(
      {
        'Type' => 'CircularArc',
        'Vertices' => [2, 3],
        'Center' => {
          'X' => 3.0,
          'Y' => 1.5
        },
        'ClockwiseFrom' => '3'
      }
    )
  end

  let(:right_angle_arc) do
    described_class.new(
      {
        'Type' => 'CircularArc',
        'Vertices' => [1, 3],
        'Center' => {
          'X' => 0.0,
          'Y' => 0.0
        },
        'ClockwiseFrom' => '7'
      }
    )
  end

  describe '#get_dot_product' do
    it 'should calculate the dot product!' do
      Edge.get_dot_product(v4, v5).should eq 11.0
    end
  end

  describe '.initialize' do
    it 'should initialize itself properly' do
      straight_edge.vertices.should eq ['1', '2']
      arc.vertices.should eq ['2', '3']
      arc.circular.should be_true
      arc.clockwise_vertex_id.should eq '3'
      arc.center.should eq Vertex.new(3.0, 1.5)
    end
  end

  describe '.find_farthest_points' do
    it 'should calculate the coordinates farthest away from the center' do
      arc.set_radius(vertices_hash)
      arc.find_farthest_points(vertices_hash)
      arc.positive_x.should eq 4.5
      arc.negative_x.should eq 1.5
      arc.positive_y.should eq 3.0
      arc.negative_y.should eq 0.0
    end
  end

  describe '.set_radius' do
    it 'should calculate the radius' do
      arc.set_radius(vertices_hash).should eq 1.5
    end
  end

  describe '.find_length' do
    it 'should return the correct length' do
      straight_edge.find_length(vertices_hash).should eq 3.0
      arc.find_length(vertices_hash).round(2).should eq 4.71
      right_angle_arc.find_length(vertices_hash).round(2).should eq 4.71
    end
  end

  describe '.translate_edge' do
    it 'should give the coordinates of the edge relative to the center' do
      v1, v2 = arc.translate_edge(vertices_hash)
      v1.x.should eq 0
      v1.y.should eq 1.5
      v2.x.should eq 0
      v2.y.should eq -1.5
    end
  end

  describe '.get_angle' do
    it 'should get the angle described by an arc' do
      arc.get_angle(vertices_hash).round(5).should eq Edge::PI
      right_angle_arc.get_angle(vertices_hash).round(5).should eq (Edge::PI/2).round(5)
    end
  end
end

