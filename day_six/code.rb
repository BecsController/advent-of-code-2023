require "pry"

# Solution part one

elf_inputs = File.open("input.txt").read.split("\n")

race_times = elf_inputs.first.split(":      ")[1].split(" ").map(&:to_i)

distance_for_races = elf_inputs[1].split(": ")[1].split(" ").map(&:to_i)

number_of_ways_to_beat = []

race_times.each_with_index do |race_time, i|
  number_of_ways_to_win = 0

  distance_for_race = distance_for_races[i]

  (1..race_time).to_a.each do |button_hold|
    distance_travelled = button_hold * (race_time - button_hold)

    number_of_ways_to_win += 1 if distance_travelled > distance_for_race
  end

  number_of_ways_to_beat << number_of_ways_to_win
end

puts "Solution One = #{number_of_ways_to_beat.inject(:*)}"

race_time = elf_inputs.first.split(":")[1].delete(" ").to_i
distance_for_race = elf_inputs[1].split(": ")[1].delete(" ").to_i

ways_to_win_two = 0

(1..race_time).to_a.each do |button_hold|
  distance_travelled = button_hold * (race_time - button_hold)

  ways_to_win_two += 1 if distance_travelled > distance_for_race
end

puts "Solution Two = #{ways_to_win_two}"


