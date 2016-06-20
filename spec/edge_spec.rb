require 'awesome_print'

require './plethora'

describe Edge do
  let(:v1) { Vertex.new(0.0, 3.0) }
  let(:v2) { Vertex.new(3.0, 3.0) }
  let(:v3) { Vertex.new(3.0, 0.0) }

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
      arc.set_radius(vertices_hash)
      arc.find_length(vertices_hash).round(2).should eq 4.71
    end
  end

end

