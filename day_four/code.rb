require "pry"

# Solution part one

elf_inputs = File.open("input.txt").read.split("\n")

card_points = {}

elf_inputs.each do |card| 
  matches = []
  card_number, numbers = card.split(":")
  card_number = card_number.delete("^0-9").to_i
  winning, mine = numbers.split("|")
  
  mine.split(" ").each do |num|
    matches << num.to_i if winning.split(" ").include?(num)
  end

  points = []
  matches.each_with_index do |match, i|
    i.zero? ? points << 1 : points << points[i - 1] * 2
  end

  card_points[card_number] = points.last
end

puts "Solution One = #{card_points.values.compact.sum}"


# Solution part two

number_of_cards = {}

elf_inputs.each_with_index do |c, i|
  card_number = i + 1
  number_of_cards[card_number] = 1
end

elf_inputs.each do |card|
  card_number, numbers = card.split(":")
  card_number = card_number.delete("^0-9").to_i

  number_to_iterate = number_of_cards[card_number]

  number_to_iterate.times do
    matches = []
    winning, mine = numbers.split("|")
    
    mine.split(" ").each do |num|
      matches << num.to_i if winning.split(" ").include?(num)
    end

    win_index = card_number + 1
    matches.count.times do
      number_of_cards[win_index] = number_of_cards[win_index] + 1
      win_index += 1
    end
  end
end

puts "Solution Two = #{number_of_cards.values.sum}"


