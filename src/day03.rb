# frozen_string_literal: true

def char_to_prio(char)
  if char.ord >= 97
    char.ord - 96
  else
    char.ord - 38
  end
end

backpack_items = nil
File.open 'input/day03_input.txt' do |puzzle_in|
  backpack_items = puzzle_in.read.split("\n")
end
backpack_sum = 0

backpack_items.each do |item|
  compartment_size = item.length / 2
  characters = item.each_char.collect { |c| char_to_prio(c) }
  common_chars = []
  backpack1 = characters[...compartment_size].uniq.sort
  backpack2 = characters[compartment_size..].uniq.sort
  index1 = index2 = 0
  while index1 < backpack1.size && index2 < backpack2.size
    if backpack1[index1] == backpack2[index2]
      common_chars << backpack2[index2]
      index1 += 1
      index2 += 1
    elsif backpack1[index1] < backpack2[index2]
      index1 += 1
    else
      index2 += 1
    end
  end
  backpack_sum += common_chars.sum
end
puts 'Backpack total:'
puts backpack_sum

backpack_sum = 0
### part 2 ###
backpack_groups = backpack_items.zip(backpack_items[1..], backpack_items[2..]).each_slice(3).map(&:first)
backpack_groups.each do |bpg|
  characters = bpg.collect { |bp| bp.each_char.collect { |c| char_to_prio(c) }.uniq.sort }
  common_chars = []
  index1 = index2 = index3 = 0
  while index1 < characters[0].size && index2 < characters[1].size && index3 < characters[2].size
    items = [characters[0][index1], characters[1][index2], characters[2][index3]]
    if items[0] == items[1] && items[1] == items[2]
      common_chars << items[0]
      index1 += 1
      index2 += 1
      index3 += 1
    end
    current_min = [items[0], items[1], items[2]].min
    index1 += 1 if items[0] == current_min
    index2 += 1 if items[1] == current_min
    index3 += 1 if items[2] == current_min
  end
  backpack_sum += common_chars.sum
end
puts 'Backpack total part 2:'
puts backpack_sum
