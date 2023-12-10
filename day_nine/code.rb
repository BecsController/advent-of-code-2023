require "pry"

# # Solution part one

report = File.open("input.txt").read.split("\n").map{ |line| line.split(" ").map(&:to_i)}

next_in_sequence = []
OASIS = []
report.each do |line|
  OASIS << line

  while !OASIS.last.all?(&:zero?)
    next_line = OASIS.last.map.with_index do |set, i|
      next_one = OASIS.last[i + 1]
      next_one - set if next_one
    end

    OASIS << next_line.compact
  end

  OASIS = OASIS.reverse
  OASIS.each_with_index do |line, i|
    if line.all?(&:zero?) # Add Zero to zero line
      line.push(0)
    else
      lower_line = OASIS[i - 1]
      diff = lower_line[-1]
      line.push(line.last + diff)
    end
  end

  next_in_sequence << OASIS.last.last
  OASIS = []
end


puts "Solution One = #{next_in_sequence.sum}"

next_in_sequence = []
OASIS = []
report.each do |line|
  OASIS << line

  while !OASIS.last.all?(&:zero?)
    next_line = OASIS.last.map.with_index do |set, i|
      next_one = OASIS.last[i + 1]
      next_one - set if next_one
    end

    OASIS << next_line.compact
  end

  OASIS = OASIS.reverse
  OASIS.each_with_index do |line, i|
    if line.all?(&:zero?) # Add Zero to zero line
      line.unshift(0)
    else
      lower_line = OASIS[i - 1]
      diff = lower_line[0]
      line.unshift(line.first - diff)
    end
  end

  next_in_sequence << OASIS.last.first
  OASIS = []
end

puts "Solution Two = #{next_in_sequence.sum}"


