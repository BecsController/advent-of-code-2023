require "pry"

# Solution part one

$grid = File.open("input.txt").read.split("\n").map{ |line| line.split("") }

$part_numbers = []
$total_x = $grid.first.count - 1
$total_y = $grid.transpose.first.count - 1

def check_directions(x, y)
  top_line = [$grid[y - 1][x - 1], $grid[y - 1][x], $grid[y - 1][x + 1]] unless y.zero?
  current_line = if x.zero?
    [$grid[y][x + 1]]
  elsif x == $total_x
    [$grid[y][x - 1]]
  else
    [$grid[y][x + 1], $grid[y][x - 1]]
  end
  bottom_line = [$grid[y + 1][x + 1], $grid[y + 1][x], $grid[y + 1][x - 1]] unless y == $total_y

  options = [top_line, current_line, bottom_line].flatten.compact
  options.delete(".")

  options.any?(/\W/)
end

def get_number_to_right(line, i)
  index_to_end = line.slice(i..-1)
  number_to_add = []
  index_to_end.each do |num|
    if num.match?(/[0-9]/)
      number_to_add << num
    else
      break
    end
  end
  number_to_add
end

def get_number_to_left(line, i)
  beginning_til_now = line.slice(0..i).reverse
  number_to_add = []
  beginning_til_now.each do |num|
    if num.match?(/[0-9]/)
      number_to_add << num
    else
      break
    end
  end
  number_to_add
end

$grid.each_with_index do |line, idx|
  line.each_with_index do |char, i|
    next if char == "."
    next unless char.match?(/[0-9]/)

    if line[i - 1].match?(/[0-9]/) == false # first number
      symbol_found = check_directions(i, idx)

      number = get_number_to_right(line, i) if symbol_found
  
      $part_numbers << number.join("").to_i if number
    end

    next_char = line[i + 1]

    next unless next_char
    next unless next_char == "." || next_char.match?(/[0-9]/) ==  false
    symbol_found = check_directions(i, idx)

    next unless symbol_found

    number = get_number_to_left(line, i).reverse.join("").to_i
    $part_numbers << number unless $part_numbers.last == number
  end
end

puts "Solution One = #{$part_numbers.sum}"


# Solution part two
$gear_ratio = {}

def options(x, y)
  top_line = [$grid[y - 1][x - 1], $grid[y - 1][x], $grid[y - 1][x + 1]] unless y.zero?
  current_line = [$grid[y][x - 1], $grid[y][x + 1]]
  bottom_line = [ $grid[y + 1][x - 1], $grid[y + 1][x], $grid[y + 1][x + 1]] unless y == $total_y

  [top_line, current_line, bottom_line]
end

def get_star_location(options, y, x)
  # [nil, [".", "6"], ["*", ".", "."]]
  above, line, below = options
  on_line_true = line&.any?("*") || false
  above_true = above&.any?("*") || false
  below_true = below&.any?("*") || false

  if on_line_true == true
    star_index = line.index("*")
    x = star_index.zero? ? x - 1 : x + 1
    "#{y}#{x}"
  elsif above_true == true 
    adjustments = [x - 1, x, x + 1]
    star_index = above.index("*")
    "#{y - 1}#{adjustments[star_index]}"
  elsif below_true == true
    adjustments = [x - 1, x, x + 1]
    star_index = below.index("*")
    "#{y + 1}#{adjustments[star_index]}"
  else
    puts "FAARK NONE"
  end
end

$grid.each_with_index do |line, idx|
  line.each_with_index do |char, i|
    next if char == "."
    next unless char.match?(/[0-9]/)

    if line[i - 1].match?(/[0-9]/) == false # first number
      options = options(i, idx)
      symbol_found = options.flatten.compact.any?("*")
      number = get_number_to_right(line, i) if symbol_found
      location = get_star_location(options, idx, i) if symbol_found
      $gear_ratio[location] = [] if $gear_ratio[location].nil?
      $gear_ratio[location] << number.join("").to_i if number
    end

    next_char = line[i + 1]

    next unless next_char
    next unless next_char == "." || next_char.match?(/[0-9]/) ==  false
    options = options(i, idx)
    symbol_found = options.flatten.compact.any?("*")
    
    next unless symbol_found
    
    number = get_number_to_left(line, i).reverse.join("").to_i

    location = get_star_location(options, idx, i)

    $gear_ratio[location] = [] if $gear_ratio[location].nil?
    $gear_ratio[location] << number unless  $gear_ratio[location].last == number
  end
end

with_counts =  $gear_ratio.values.group_by(&:count)[2]
ratios = with_counts.map{ |s| s.first * s.last }

puts "Solution Two = #{ratios.sum}"


