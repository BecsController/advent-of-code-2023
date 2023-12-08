require "pry"

# Solution part one

elf_inputs = File.open("input.txt").read.split("\n")

MAGIC_NUMBERS = {
  "red": 12,
  "green": 13,
  "blue": 14
}

def check_games(inputs)
  game_nums = []
  inputs.each do |line|
    number, game = line.split(":")
    game_number = number.delete("^0-9").to_i

    numbers_only = game.split(";").map{ |s| s.split(",")}.flatten.map { |c| c.delete("^0-9")&.to_i }

    next if numbers_only.any?{ |n| n > 14 }
      
    sets = game.split(";").map do |set|
      set = set.split(";").first.split(",")

      blue_num = set.select { |s| s.include?("blue")}.first&.delete("^0-9")&.to_i || 0
      red_num = set.select { |s| s.include?("red")}.first&.delete("^0-9")&.to_i || 0
      green_num = set.select { |s| s.include?("green")}.first&.delete("^0-9")&.to_i || 0

      blue_num <= MAGIC_NUMBERS[:blue] && red_num <= MAGIC_NUMBERS[:red] && green_num <= MAGIC_NUMBERS[:green]
    end
    game_nums << game_number if sets.all? 
  end
  game_nums.sum
end


puts "Solution One = #{check_games(elf_inputs)}"


# Solution part two

def lowest_poss_games(inputs)
  powers = inputs.map do |line|
    number, game = line.split(":")

    sets = game.split(";").map{ |s| s.split(",")}.flatten

    lowest_green = sets.group_by{ |s| s.include?("green")}[true].map{ |c| c.delete("^0-9")&.to_i}.max
    lowest_red = sets.group_by{ |s| s.include?("red")}[true].map{ |c| c.delete("^0-9")&.to_i}.max
    lowest_blue = sets.group_by{ |s| s.include?("blue")}[true].map{ |c| c.delete("^0-9")&.to_i}.max

    lowest_blue * lowest_green * lowest_red
  end
  powers.sum
end

puts "Solution Two = #{lowest_poss_games(elf_inputs)}"
