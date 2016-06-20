require 'awesome_print'

require './plethora'

describe Shape do
  let(:rectangle) { described_class.new(Fixtures::RECTANGLE_FILE) }
  let(:cut_circle) { described_class.new(Fixtures::CUT_CIRCLE_FILE) }
  let(:extruded_circle) { described_class.new(Fixtures::EXTRUDED_CIRCLE_FILE) }
  let(:vase) { described_class.new(Fixtures::VASE_FILE) }

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

  describe '.process_edges' do
    it 'should mark concave and convex edges properly, and also set the radius for any circular edges' do
      cut_circle.process_edges
      cut_circle.edges['22'].concave.should be_true
      cut_circle.edges['22'].radius.should eq 0.5

      extruded_circle.process_edges
      extruded_circle.edges['8419032'].concave.should be_false
      extruded_circle.edges['8419032'].radius.should eq 0.5

      rectangle.process_edges
      rectangle.edges['33476626'].concave.should be_false
    end
  end

  describe '.get_bounding_box_dimensions' do
    it 'should get the correct dimensions of the stock rectangle that fully encloses the shape' do
      cut_circle.process_edges
      circle_x, circle_y = cut_circle.get_bounding_box_dimensions
      circle_x.should eq 2.0
      circle_y.should eq 1.0

      rectangle.process_edges
      rectangle_x, rectangle_y = rectangle.get_bounding_box_dimensions
      rectangle_x.should eq 5.0
      rectangle_y.should eq 3.0

      extruded_circle.process_edges
      extruded_circle_x, extruded_circle_y = extruded_circle.get_bounding_box_dimensions
      extruded_circle_x.should eq 2.5
      extruded_circle_y.should eq 1.0
    end
  end

  describe '.get_materials_cost' do
    it 'should accurately calculate the cost of the materials' do
      cut_circle.process_edges
      cut_circle.get_materials_cost.round(2).should eq 1.73

      rectangle.process_edges
      rectangle.get_materials_cost.round(2).should eq 11.86

      extruded_circle.process_edges
      extruded_circle.get_materials_cost.round(2).should eq 2.15
      vase.process_edges
      vase.get_materials_cost.round(2).should eq 18.76
    end
  end

  describe '.get_laser_cutting_cost' do
    it 'should accurately calculate the laser cutting cost' do
  #    cut_circle.process_edges
  #    cut_circle.get_laser_cutting_cost.round(2).should eq 2.32

  #    rectangle.process_edges
  #    rectangle.get_laser_cutting_cost.round(2).should eq 2.24

      vase.process_edges
      vase.get_laser_cutting_cost.round(2).should eq 4.58
    end
  end

  describe '.get_total_costs' do
    it 'should calculate the cost of machining a piece' do
      extruded_circle.get_total_costs.should eq 4.47
      cut_circle.get_total_costs.should eq 4.06
      rectangle.get_total_costs.should eq 14.1
      vase.get_total_costs.should eq 23.34
    end
  end
end
