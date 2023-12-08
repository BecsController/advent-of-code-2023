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
  
    soil_index = soil_index.compact.first || seed
  
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
  
  
    location_index = MAPS["humidity-to-location map"][:source].map.with_index do |range, i|
      if range.include?(humidity_index)
        MAPS["humidity-to-location map"][:destination][i].first + (humidity_index - range.first)
      elsif i == -1
        humidity_index
      else
        next
      end
    end
  
    location_index.compact.first || humidity_index
  end
end

puts "Solution One = #{get_locations(seeds).min}"

binding.pry
# Solution part two

part_two_locations = part_two_seeds.map do |range|
  puts range
  get_locations(range.to_a).min
end

part_two_seeds = seeds.each_slice(2).map do |chunk|
  start, length = chunk

  (start..(start + length))
end


def reverse_from_location(location)

  
  location_index = MAPS["humidity-to-location map"][:source].map.with_index do |range, i|
    if range.include?(humidity_index)
      MAPS["humidity-to-location map"][:destination][i].first + (humidity_index - range.first)
    elsif i == -1
      humidity_index
    else
      next
    end
  end

  location_index.compact.first || humidity_index

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
  
    soil_index = soil_index.compact.first || seed
  
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
  
  
    location_index = MAPS["humidity-to-location map"][:source].map.with_index do |range, i|
      if range.include?(humidity_index)
        MAPS["humidity-to-location map"][:destination][i].first + (humidity_index - range.first)
      elsif i == -1
        humidity_index
      else
        next
      end
    end
  
    location_index.compact.first || humidity_index
  end
end
puts "Solution Two = #{part_two_locations.min}"


