# frozen_string_literal: true

input_string = nil
File.open 'input/day4_input.txt' do |puzzle_in|
  input_string = puzzle_in.read
end

def contains(pair1, pair2)
  pair1[0] <= pair2[0] && pair1[1] >= pair2[1]
end

def overlaps(pair1, pair2)
  pair1[1] >= pair2[0]
end

section_pairs = input_string.split("\n").collect { |ss| ss.split(',').collect { |s| s.split('-').collect(&:to_i) } }
sorted_pairs = section_pairs.collect do |section_pair|
  section_pair.sort do |pair1, pair2|
    (pair1[0] <=> pair2[0]).zero? ? pair2[1] <=> pair1[1] : pair1[0] <=> pair2[0]
  end
end
redundants = sorted_pairs.select do |sorted_pair|
  # puts sorted_pair.inspect + "\t" + contains(sorted_pair[0], sorted_pair[1]).inspect
  contains(sorted_pair[0], sorted_pair[1])
end.count

puts redundants

### part 2 ###

redundants = sorted_pairs.select do |sorted_pair|
  # puts sorted_pair.inspect + "\t" + contains(sorted_pair[0], sorted_pair[1]).inspect
  overlaps(sorted_pair[0], sorted_pair[1])
end.count

puts redundants
