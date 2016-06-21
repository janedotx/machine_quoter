def fixture(filename)
  File.expand_path("../fixtures/#{filename}", __FILE__)
end

module Fixtures
  RECTANGLE_FILE = fixture('rectangle.json')
  CUT_CIRCLE_FILE = fixture('cut_circular_arc.json')
  EXTRUDED_CIRCLE_FILE = fixture('extruded_circular_arc.json')
  VASE_FILE = fixture('vase.json')
  SLANT_FILE = fixture('slant.json')
  ICECREAM_FILE = fixture('icecream.json')
end
