require "pry"

# Solution part one

elf_inputs = File.open("test_input.txt").read.split("\n\n")

MAPS = {}

title, seeds = elf_inputs[0].split(":")
seeds = seeds.split(" ").map(&:to_i)
maps = elf_inputs.slice(1..-1)

maps.each do |map|
  title, numbers = map.split(":\n")
  sets = numbers.split("\n")
  sets.each_with_index do |set, i|
    dest, source, length = set.split(" ").map(&:to_i)
    dest_range = (dest..(dest + length))
    source_range = (source..(source + length))

    MAPS[title] = { destination: [], source: [] } if i.zero?

    MAPS[title][:destination] << dest_range
    MAPS[title][:source] << source_range
  end
end

def get_next_location_index(map_title, previous_index)
  next_index = MAPS[map_title][:source].map.with_index do |range, i|
    if range.include?(previous_index)
      MAPS[map_title][:destination][i].first + (previous_index - range.first)
    elsif i == -1
      previous_index
    else
      next 
    end
  end

  next_index = next_index.compact.first || previous_index
end

@route = {}
def get_locations(seeds)
  seeds.map do |seed|
    soil_index = get_next_location_index("seed-to-soil map", seed)

    @route[seed] = []
    @route[seed] << [seed, soil_index]

    fertilizer_index = get_next_location_index("soil-to-fertilizer map", soil_index)
    @route[seed] << [soil_index, fertilizer_index]

    water_index = get_next_location_index("fertilizer-to-water map", fertilizer_index)
    @route[seed] << [fertilizer_index, water_index]

    light_index = get_next_location_index("water-to-light map", water_index)
    @route[seed] << [water_index, light_index]
  
    temperature_index = get_next_location_index("light-to-temperature map", light_index)
    @route[seed] << [light_index, temperature_index]
  
    humidity_index = get_next_location_index("temperature-to-humidity map", temperature_index)
    @route[seed] << [temperature_index, humidity_index]
  
    location_index = get_next_location_index("humidity-to-location map", humidity_index)
    @route[seed] << [humidity_index, location_index]

    location_index
  end
end

puts "Solution One = #{get_locations(seeds).min}"

# Solution part two
@location_to_seed = 0
@route_two = {}

def get_next_location_index_in_reverse(map_title, previous_index)
  next_index = MAPS[map_title][:destination].map.with_index do |range, i|
    if range.include?(previous_index)
      MAPS[map_title][:source][i].first + (previous_index - range.first)
    elsif i == -1
      previous_index
    else
      next 
    end
  end

  next_index = next_index.compact.first || previous_index
end

def reverse_from_location(location) 
  @route_two[location] = []
  humidity_index = get_next_location_index_in_reverse("humidity-to-location map", location)
  @route_two[location] << [location, humidity_index]

  temperature_index = get_next_location_index_in_reverse("temperature-to-humidity map", humidity_index)
  @route_two[location] << [humidity_index, temperature_index]

  light_index = get_next_location_index_in_reverse("light-to-temperature map", temperature_index)
  @route_two[location] << [temperature_index, light_index]
  
  water_index = get_next_location_index_in_reverse("water-to-light map", light_index)
  @route_two[location] << [light_index, water_index]
  
  fertilizer_index = get_next_location_index_in_reverse("fertilizer-to-water map", water_index)
  @route_two[location] << [water_index, fertilizer_index]

  soil_index = get_next_location_index_in_reverse("soil-to-fertilizer map", fertilizer_index)
  @route_two[location] << [fertilizer_index, soil_index]

  seed_index = get_next_location_index_in_reverse("seed-to-soil map", soil_index)
  @route_two[location] << [soil_index, seed_index]

  @location_to_seed = location if @part_two_seeds.include?(seed_index)
end

@part_two_seeds = []

seeds.each_slice(2).map do |chunk|
  start, length = chunk
  
  @part_two_seeds << Array(start..(start + length)).sort.uniq
end
@part_two_seeds = @part_two_seeds.flatten.sort.uniq;

@locations = get_locations(@part_two_seeds)

@locations.sort.each do |location|
  reverse_from_location(location)

  break if @location_to_seed.nonzero?
end

puts "Solution Two = #{@location_to_seed}"

# first, last = [2041142901, 113138307]
# arr = Array(first..(first + last)).sort;

# first, last = [302673608, 467797997] 
# arr_two = Array(first..(first + last)).sort;

# first, last = [1787644422, 208119536]
# arr_three = Array(first..(first + last)).sort;

# first, last = [143576771, 99841043]
# arr_four = Array(first..(first + last)).sort;

# first, last = [4088720102, 111819874]
# arr_five = Array(first..(first + last)).sort;

# first, last = [946418697, 13450451]
# arr_six = Array(first..(first + last)).sort;

# first, last = [3459931852, 262303791]
# arr_seven = Array(first..(first + last)).sort;

# first, last = [2913410855,533641609]
# arr_eight = Array(first..(first + last)).sort;

# first, last = [2178733435, 26814354]
# arr_nine = Array(first..(first + last)).sort;

# first, last = [1058342395, 175406592]

# arr_ten = Array(first..(first + last)).sort;

# all_arr = arr + arr_two + arr_three + arr_four + arr_five + arr_six + arr_seven + arr_eight + arr_nine + arr_ten;

# @part_two_seeds = all_arr.flatten.uniq.sort;