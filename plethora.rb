require './shape'

file = ARGV[0]

costs = Shape.new(file).get_total_costs

puts "#{costs} dollars"
puts
