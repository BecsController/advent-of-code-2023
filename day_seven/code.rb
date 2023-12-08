require "pry"

# Solution part one

elf_inputs = File.open("input.txt").read.split("\n")

CARD_COMBOS_START = ["A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2"].repeated_permutation(5).to_a.map{|combo| combo.join("")}

possible_cards = elf_inputs.map{ |t| t.split(" ").first}

CARD_COMBOS = CARD_COMBOS_START.select{|c| possible_cards.include?(c)}

RANK_ORDER = {
  "five": 7,
  "four": 6,
  "house": 5,
  "three": 4,
  "two_pair": 3,
  "pair": 2,
  "high": 1
}

def get_rank(hand)
  if hand.include?(5)
    RANK_ORDER[:five]
  elsif hand.include?(4)
    RANK_ORDER[:four]
  elsif hand.include?(2) && hand.include?(3)
    RANK_ORDER[:house]
  elsif hand.include?(3)
    RANK_ORDER[:three]
  elsif hand.select{ |v| v == 2}.count == 2
    RANK_ORDER[:two_pair]
  elsif hand.include?(2)
    RANK_ORDER[:pair]
  elsif hand.uniq.include?(1)
    RANK_ORDER[:high]
  else
    binding.pry
  end
end

ranks = []

elf_inputs.each do |hand|
  hand, bid = hand.split(" ")
  counted_hand = hand.chars.sort.group_by(&:chars).transform_values(&:size)

  rank = get_rank(counted_hand.values.sort)
  ranks << {hand: hand, bid: bid, rank: rank} 
end

grouped = ranks.group_by{|i| i[:rank]}.sort

def get_values(hand)
  hand.chars.map{ |ch| CARD_RANK.index(ch) }
end

def get_number_from_card(card)
  get_values(card).map(&:to_s).join("").to_i
end

final_ranks = []

grouped.map do |rank, hands|
  if hands.one?
    final_ranks << hands
  else
    just_hands = hands.map{|h| h[:hand]}
    handed_rank = just_hands.map { |hand| {hand: hand, number: CARD_COMBOS.index(hand)}}
    sorted = handed_rank.sort_by{|h| h[:number]}.reverse

    sorted.each_with_index do |hand, i|
      found = hands.select{|h| h[:hand] == hand[:hand]}
      found.first[:secondary_rank] = i
      final_ranks << found
    end
  end
end

multipliers = []
winnings = []
final_ranks.flatten.each_with_index do |hand, i|
  multiplier = i + 1
  win = hand[:bid].to_i * multiplier
  multipliers << {bid: hand[:bid].to_i, mult: multiplier}
  winnings << win
end


puts "Solution One = #{winnings.sum}"

CARD_RANKS = ["A", "K", "Q", "T", "9", "8", "7", "6", "5", "4", "3", "2", "J"]
PT_2CARD_COMBOS_START = CARD_RANKS.repeated_permutation(5).to_a.map{|combo| combo.join("")}

possible_cards = elf_inputs.map{ |t| t.split(" ").first}
ranks_2 = []

CARD_COMBOS_2 = PT_2CARD_COMBOS_START.select{|c| possible_cards.include?(c)}

elf_inputs.each do |hand|
  hand, bid = hand.split(" ")
  old_chars = hand.chars
  chars = hand.chars
  
  if chars.include?("J")
    had_j = true
    sorted = chars.sort.group_by(&:chars).transform_values{ |v| [v.uniq, v.size]}
    j_count = sorted.find{ |k, _v| k == ["J"]}[1][1]
    highest_number = sorted.values.reject{|v| v[0] == ["J"]}.map(&:last).max
    highest = sorted.values.reject{|v| v[0] == ["J"]}.find{ |s| s[1] == highest_number}
    
    if j_count == 5
      character = "A"
    elsif j_count >= 3
      character = sorted.values.reject{|v| v[0] == ["J"]}.map(&:first).flatten.map{ |ch| [ch, CARD_RANKS.index(ch)] }.sort_by { |ch| ch[1]}.first.first
    elsif j_count == 2 && highest_number && highest_number > 1
      character = sorted.values.reject{|v| v[0] == ["J"]}.find{ |s| s[1] == highest_number}[0].flatten 
    elsif j_count == 1 && highest_number && highest_number > 2
      character = sorted.values.reject{|v| v[0] == ["J"]}.find{ |s| s[1] == highest_number}[0].flatten 
    elsif highest_number == 2
      character = sorted.values.reject{|v| v[0] == ["J"]}.find{ |s| s[1] == highest_number}[0].flatten 
    elsif highest_number
      find_ranks = chars.map{ |ch| [ch, CARD_RANKS.index(ch)] }.sort_by { |ch| ch[1]}
      character = find_ranks.first[0]
    else
      binding.pry
      character = "A"
    end

    j_count.times do 
      chars[chars.index("J")] = character
    end
  end
  counted_hand = chars.flatten.sort.group_by(&:chars).transform_values(&:size)

  rank = get_rank(counted_hand.values.sort)
  ranks_2 << {hand: hand, bid: bid, rank: rank} 
end

grouped = ranks_2.group_by{|i| i[:rank]}.sort
final_ranks_2 = []

grouped.map do |rank, hands|
  just_hands = hands.map{|h| h[:hand]}
  handed_rank = just_hands.map { |hand| {hand: hand, number: CARD_COMBOS_2.index(hand)}}
  sorted = handed_rank.sort_by{|h| h[:number]}.reverse

  sorted.each_with_index do |hand, i|
    found = hands.select{|h| h[:hand] == hand[:hand]}
    found.first[:secondary_rank] = i
    final_ranks_2 << found
  end
end

binding.pry
multipliers = []
winnings = []
final_ranks_2.flatten.each_with_index do |hand, i|
  multiplier = i + 1
  win = hand[:bid].to_i * multiplier
  multipliers << {bid: hand[:bid].to_i, mult: multiplier}
  winnings << win
end


puts "Solution Two = #{winnings.sum}"


