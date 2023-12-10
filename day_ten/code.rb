require "pry"

# Solution part one

@elf_inputs = File.open("input.txt").read.split("\n").map(&:chars)

@starting_x = 0
@starting_y = 0
@current_x = 0
@current_y = 0
back_at_start = false
@steps = 0
@last_direction_change = ""
@char = "S"
@total_coords = []
@coords_of_loop = []

@elf_inputs.each_with_index do |line, y|
  line.each_with_index do |x, i|
    @total_coords << [y, i]
  end
end

PIPE_POTENTIALS = {
  "|": {
    "R": [],
    "L": [],
    "U": ["|", "F", "7"],
    "D": ["|", "L", "J"]
  },
  "-": {
    "R": ["7", "J", "-"],
    "L": ["F", "L", "-"],
    "U": [],
    "D": []
  },
  "L": {
    "R": ["-", "J", "7"],
    "L": [],
    "U": ["F", "|", "7"],
    "D": []
  },
  "J": {
    "R": [],
    "L": ["-", "L", "F"],
    "U": ["|", "7", "F"],
    "D": []
  },
  "7": {
    "R": [],
    "L": ["F", "-", "L"],
    "U": [],
    "D": ["|", "J", "L"]
  },
  "F": {
    "R": ["7", "-", "J"],
    "L": [],
    "U": [],
    "D": ["|", "L", "J"]
  }
}

OPPOSITES = {
  "R": "L",
  "L": "R",
  "U": "D",
  "D": "U"
}

@elf_inputs.each do |map|
  if map.include?("S")
    @starting_x = map.index("S")
    @starting_y = @elf_inputs.transpose[@starting_x].index("S")

    @current_x = @starting_x
    @current_y = @starting_y
  end
end

def adjust_based_on_direction_choice(direction_choice)
  case direction_choice
  when "R"
    @current_x += 1
  when "L"
    @current_x -= 1
  when "U"
    @current_y -= 1
  when "D"
    @current_y += 1
  else
    binding.pry
  end
end

def check_direction_for_potentials(char, x, y)
  right = @elf_inputs[y][x + 1] unless x == @elf_inputs.first.count - 1
  left = @elf_inputs[y][x - 1] unless x.zero?
  up = @elf_inputs[y - 1][x] unless y.zero?
  down = @elf_inputs[y + 1][x] unless y == @elf_inputs.count - 1

  options = [right, left, up, down]

  if char == "S"
    @elf_inputs[@current_y][@current_x] = "7"
    char = "7"
  end

  direction_options = options.flat_map.with_index do |o, i|    
    backwards = @last_direction_change.empty? ? "yes" : OPPOSITES[@last_direction_change.to_sym].to_sym

    PIPE_POTENTIALS[char.to_sym].keys[i] if PIPE_POTENTIALS[char.to_sym][PIPE_POTENTIALS[char.to_sym].keys[i]].include?(o) && PIPE_POTENTIALS[char.to_sym].keys[i] != backwards
  end.compact

  @last_direction_change = direction_options.first.to_s
  adjust_based_on_direction_choice(@last_direction_change)

  @char = @elf_inputs[@current_y][@current_x]
  @steps += 1
end

while back_at_start == false
  @coords_of_loop << [@current_y, @current_x]
  check_direction_for_potentials(@char, @current_x, @current_y)

  if @current_x == @starting_x && @current_y == @starting_y
    back_at_start = true
  end
end

@diff = @total_coords - @coords_of_loop

def could_be_enclosed?(coord)
  y, x = coord
  left = [y, x - 1]
  right = [y, x + 1]
  up = [y - 1, x]
  down = [y + 1, x]
  
  # coord either pipe or in diff
  [left, right, up, down].all? do |dir|
    @diff.include?(dir) || @coords_of_loop.include?(dir)
  end
end

while !@diff.all? { |c| could_be_enclosed?(c) }
  @diff.each do |coord|
    unless could_be_enclosed?(coord)
      @diff.delete(coord)
    end
  end
end

@diff.each do |diff|
  y, x = diff

  vertical = ["F", "-", "7"]
  up = @elf_inputs.transpose[x].slice(0, y).select{ |c| vertical.include?(c)}

  in_pipe = up.count.odd?

  @diff.delete(diff) unless in_pipe
end

puts "Solution One = #{@steps/2}"

# Solution part two

puts "Solution two = #{@diff.count}"