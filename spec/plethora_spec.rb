require './plethora'

describe Shape do
  it 'should be right' do
    s = Shape.new(Fixtures::RECTANGLE_FILE)
  end
end

describe 'stuff' do
  it 'pythagorases' do
    p1 = Vertex.new(0, 0, 0)
    p2 = Vertex.new(1, 1, 1)
    get_distance_between(p1, p2).should eq Math.sqrt(2)
  end
end
