def fixture(filename)
  File.expand_path("../fixtures/#{filename}", __FILE__)
end

module Fixtures
  RECTANGLE_FILE = fixture('rectangle.json')
end
