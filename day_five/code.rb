require "pry"

# Solution part one

elf_inputs = File.open("input.txt").read.split("\n\n")

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

@route = {}
def get_locations(seeds)
  seeds.map do |seed|
    soil_index = MAPS["seed-to-soil map"][:source].map.with_index do |range, i|
      if range.include?(seed)
        MAPS["seed-to-soil map"][:destination][i].first + (seed - range.first)
      elsif i == -1
        seed
      else
        next
      end
    end
    @route[seed] = []
    soil_index = soil_index.compact.first || seed
    @route[seed] << [seed, soil_index]
    fertilizer_index = MAPS["soil-to-fertilizer map"][:source].map.with_index do |range, i|
      if range.include?(soil_index)
        MAPS["soil-to-fertilizer map"][:destination][i].first + (soil_index - range.first)
      elsif i == -1
        soil_index
      else
        next
      end
    end
  
    fertilizer_index = fertilizer_index.compact.first || soil_index
    @route[seed] << [soil_index, fertilizer_index]
    water_index = MAPS["fertilizer-to-water map"][:source].map.with_index do |range, i|
      if range.include?(fertilizer_index)
        MAPS["fertilizer-to-water map"][:destination][i].first + (fertilizer_index - range.first)
      elsif i == -1
        fertilizer_index
      else
        next
      end
    end
  
    water_index = water_index.compact.first || fertilizer_index
    @route[seed] << [fertilizer_index, water_index]
    light_index = MAPS["water-to-light map"][:source].map.with_index do |range, i|
      if range.include?(water_index)
        MAPS["water-to-light map"][:destination][i].first + (water_index - range.first)
      elsif i == -1
        water_index
      else
        next
      end
    end
  
    light_index = light_index.compact.first || water_index
    @route[seed] << [water_index, light_index]
  
    temperature_index = MAPS["light-to-temperature map"][:source].map.with_index do |range, i|
      if range.include?(light_index)
        MAPS["light-to-temperature map"][:destination][i].first + (light_index - range.first)
      elsif i == -1
        light_index
      else
        next
      end
    end
  
    temperature_index = temperature_index.compact.first || light_index
    @route[seed] << [light_index, temperature_index]
  
    humidity_index = MAPS["temperature-to-humidity map"][:source].map.with_index do |range, i|
      if range.include?(temperature_index)
        MAPS["temperature-to-humidity map"][:destination][i].first + (temperature_index - range.first)
      elsif i == -1
        temperature_index
      else
        next
      end
    end
  
    humidity_index = humidity_index.compact.first || temperature_index
    @route[seed] << [temperature_index, humidity_index]
  
    location_index = MAPS["humidity-to-location map"][:source].map.with_index do |range, i|
      if range.include?(humidity_index)
        MAPS["humidity-to-location map"][:destination][i].first + (humidity_index - range.first)
      elsif i == -1
        humidity_index
      else
        next
      end
    end
    @route[seed] << [humidity_index, location_index.compact.first || humidity_index]
    location_index.compact.first || humidity_index
  end
end

puts "Solution One = #{get_locations(seeds).min}"

# Solution part two
@location_to_seed = 0
@route_two = {}

def reverse_from_location(location) 
  # grab range from source, if it includes the current index then grab corresponding direction or return current index
  @route_two[location] = []
  humidity_index = MAPS["humidity-to-location map"][:destination].map.with_index do |range, i|
    if range.include?(location)
      MAPS["humidity-to-location map"][:source][i].first + (location - range.first)
    elsif i == -1
      location
    else
      next
    end
  end.compact.first

  humidity_index = humidity_index.nil? ? location : humidity_index
  @route_two[location] << [location, humidity_index]

  temperature_index = MAPS["temperature-to-humidity map"][:destination].map.with_index do |range, i|
    if range.include?(humidity_index)
      MAPS["temperature-to-humidity map"][:source][i].first + (humidity_index - range.first)
    elsif i == -1
      humidity_index
    else
      next
    end
  end.compact.first

  temperature_index = temperature_index.nil? ? humidity_index : temperature_index

  @route_two[location] << [humidity_index, temperature_index]
  light_index = MAPS["light-to-temperature map"][:destination].map.with_index do |range, i|
    if range.include?(temperature_index)
      MAPS["light-to-temperature map"][:source][i].first + (temperature_index - range.first)
    elsif i == -1
      temperature_index
    else
      next
    end
  end.compact.first

  light_index = light_index.nil? ? temperature_index : light_index
  @route_two[location] << [temperature_index, light_index]
  
  water_index = MAPS["water-to-light map"][:destination].map.with_index do |range, i|
    if range.include?(light_index)
      MAPS["water-to-light map"][:source][i].first + (light_index - range.first)
    elsif i == -1
      light_index
    else
      next
    end
  end.compact.first

  water_index = water_index.nil? ? light_index : water_index
  @route_two[location] << [light_index, water_index]
  
  fertilizer_index = MAPS["fertilizer-to-water map"][:destination].map.with_index do |range, i|
    if range.include?(water_index)
      MAPS["fertilizer-to-water map"][:source][i].first + (water_index - range.first)
    elsif i == -1
      water_index
    else
      next
    end
  end.compact.first

  fertilizer_index = fertilizer_index.nil? ? water_index : fertilizer_index
  @route_two[location] << [water_index, fertilizer_index]

  soil_index = MAPS["soil-to-fertilizer map"][:destination].map.with_index do |range, i|
    if range.include?(fertilizer_index)
      MAPS["soil-to-fertilizer map"][:source][i].first + (fertilizer_index - range.first)
    elsif i == -1
      fertilizer_index
    else
      next
    end
  end.compact.first

  soil_index = soil_index.nil? ? fertilizer_index : soil_index

  @route_two[location] << [fertilizer_index, soil_index]

  seed_index = MAPS["seed-to-soil map"][:destination].map.with_index do |range, i|
    if range.include?(soil_index)
      MAPS["seed-to-soil map"][:source][i].first + (soil_index - range.first)
    elsif i == -1
      seed
    else
      next
    end
  end.compact.first

  seed_index = seed_index.nil? ? soil_index : seed_index
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