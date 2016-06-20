def fixture(filename)
  File.expand_path("../fixtures/#{filename}", __FILE__)
end

module Fixtures
  RECTANGLE_FILE = fixture('rectangle.json')
  CUT_CIRCLE_FILE = fixture('cut_circular_arc.json')
  EXTRUDED_CIRCLE_FILE = fixture('extruded_circular_arc.json')
end
