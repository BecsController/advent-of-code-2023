require "pry"

# Solution part one

elf_inputs = File.open("input.txt").read.split("\n")

def convert(input)
  numbers = input.map { |line| line.delete("^0-9") }
  numbers.map { |num| "#{num[0]}#{num[-1]}".to_i }.sum
end

puts "Solution One = #{convert(elf_inputs)}"


# Solution part two
WORDS = {
  one: "o1e",
  two: "t2o",
  three: "t3e",
  four: "f4r",
  five: "f5e", 
  six: "s6x", 
  seven: "s7n", 
  eight: "e8t", 
  nine: "n9e"
}

new_inputs = elf_inputs.map do |line|
  WORDS.each do |k, v|
    line = line.gsub(k.to_s, v)
  end

  line
end

puts "Solution Two = #{convert(new_inputs)}"
