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

  describe '.get_bounding_box_dimensions' do
    it 'should get the correct dimensions of the stock rectangle that fully encloses the shape' do
      cut_circle.connect_edges
      circle_x, circle_y = cut_circle.get_bounding_box_dimensions
      circle_x.should eq 2.0
      circle_y.should eq 1.0

      rectangle.connect_edges
      rectangle_x, rectangle_y = rectangle.get_bounding_box_dimensions
      rectangle_x.should eq 5.0
      rectangle_y.should eq 3.0

      extruded_circle.connect_edges
      extruded_circle_x, extruded_circle_y = extruded_circle.get_bounding_box_dimensions
      extruded_circle_x.should eq 2.5
      extruded_circle_y.should eq 1.0
    end
  end

  describe '.get_materials_cost' do
    it 'should accurately calculate the cost of the materials' do
      cut_circle.connect_edges
      cut_circle.get_materials_cost.round(2).should eq 1.73

      rectangle.connect_edges
      rectangle.get_materials_cost.round(2).should eq 11.86

      extruded_circle.connect_edges
      extruded_circle.get_materials_cost.round(2).should eq 2.15
    end
  end

  describe '.get_total_costs' do
    it 'should calculate the cost of machining a piece' do
      extruded_circle.connect_edges
      puts extruded_circle.get_total_costs

      rectangle.connect_edges
      puts rectangle.get_total_costs
    end
  end
end
