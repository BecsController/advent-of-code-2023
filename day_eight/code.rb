require "pry"

# # Solution part one

directions, keys = File.open("input.txt").read.split("\n\n")
keys = keys.split("\n")
step_count = 0
current = "AAA"
directions = directions.chars.map { |d| d == "L" ? 0 : 1 }

END_LOCATION = "ZZZ"
MAP = {}
keys.map do |key|
  source, options = key.split("=")
  left, right = options.delete(")").delete("(").split(",")
  MAP[source.strip] = [left.strip, right.strip]
end

next_direction = directions.cycle
while current != END_LOCATION
  current = MAP[current][next_direction.next]
  step_count += 1
end

puts "Solution One = #{step_count}"

steps_two = 0
overall = MAP.keys.select{ |source| source[-1] == "A" }.map do |current|
  steps_two = 0
  next_direction = directions.cycle
  while current[-1] != "Z"
    current = MAP[current][next_direction.next]
    steps_two += 1
  end
  
  steps_two
end

least_common_multiple = overall.reduce(:lcm)

puts "Solution Two = #{least_common_multiple}"


