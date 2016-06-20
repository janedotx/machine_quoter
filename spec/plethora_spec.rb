require 'awesome_print'

require './plethora'

describe Shape do
  let(:rectangle) { described_class.new(Fixtures::RECTANGLE_FILE) }
  let(:cut_circle) { described_class.new(Fixtures::CUT_CIRCLE_FILE) }
  let(:extruded_circle) { described_class.new(Fixtures::EXTRUDED_CIRCLE_FILE) }

  describe '.initialize' do

    it 'should initialize itself properly' do
      rectangle.vertices['32854180'].x.should eq 0.0
      rectangle.vertices['32854180'].y.should eq 0.0

      rectangle.vertices['27252167'].x.should eq 0.0
      rectangle.vertices['27252167'].y.should eq 3.0

    end
  end

  describe '.find_origin' do
    it 'should work' do
      rectangle.find_origin.should eq '32854180'
    end
  end

  describe '.find_edges_by_vertex' do
    it 'should work' do
      rectangle.find_edges_by_vertex('32854180').sort.should eq ["33476626", "9799115"]
    end
  end

  describe '.find_edge_by_vertices' do
    it 'should work' do
      rectangle.find_edge_by_vertices('23458411', '32854180').should eq '9799115'
    end
  end

  describe '.get_neighboring_vertices' do
    it 'should get the correct neighbors' do
      rectangle.get_neighboring_vertices('32854180').sort.should eq ['23458411', '27252167']
    end
  end

  describe '.connect_edges' do
    it 'should create a linked list of edges such that those edges are traversed in clockwise order' do
      rectangle.connect_edges
      rectangle.edges['33476626'].next.should eq '43942917'
      rectangle.edges['43942917'].next.should eq '2606490'
      rectangle.edges['2606490'].next.should eq '9799115'
      rectangle.edges['9799115'].next.should eq '33476626'

      cut_circle.connect_edges
      cut_circle.edges['20'].next.should eq '21'
      cut_circle.edges['21'].next.should eq '22'
      cut_circle.edges['22'].next.should eq '23'
      cut_circle.edges['23'].next.should eq '20'
    end

    it 'should mark concave and convex edges properly' do
      cut_circle.connect_edges
      cut_circle.edges['22'].concave.should be_true
      ap cut_circle.edges

      extruded_circle.connect_edges
      ap extruded_circle.edges
      extruded_circle.edges['8419032'].concave.should be_false
    end
  end
end

describe 'stuff' do
  it 'pythagorases' do
    p1 = Vertex.new( 0, 0)
    p2 = Vertex.new(1, 1)
    get_distance_between(p1, p2).should eq Math.sqrt(2)
  end
end
