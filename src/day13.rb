# frozen_string_literal: true

require 'json'
input_string = nil
File.open 'input/day13_input.txt' do |puzzle_in|
  input_string = puzzle_in.read
end

# input_string = "[1,1,3,1,1]
# [1,1,5,1,1]

# [[1],[2,3,4]]
# [[1],4]

# [9]
# [[8,7,6]]

# [[4,4],4,4]
# [[4,4],4,4,4]

# [7,7,7,7]
# [7,7,7]

# []
# [3]

# [[[]]]
# [[]]

# [1,[2,[3,[4,[5,6,7]]]],8,9]
# [1,[2,[3,[4,[5,6,0]]]],8,9]"

input_string += "
[[2]]
[[6]]"

def check_pair(a, b)
  if a.instance_of?(Integer) && b.instance_of?(Integer)
    # puts "Comparing values: #{a} vs #{b}"
    if a < b
      [true, true]
    elsif a > b
      [false, true]
    else
      [nil, false]
    end
  elsif a.class != b.class
    return [a.nil?, false] if a.nil? || b.nil?

    a_new = a.instance_of?(Array) ? a : [a]
    b_new = b.instance_of?(Array) ? b : [b]
    # puts "Adusting values: #{a} -> #{a_new} and #{b} -> #{b_new}"
    check_pair(a_new, b_new)
  else
    # both lists
    # puts "Comparing lists: #{a} vs #{b}"
    comparisons = a.zip(b)
    comparisons.each do |comp|
      result, final = check_pair(*comp)
      return [result, true] if final
    end
    return [false, true] if b.size < a.size
    return [true, true] if b.size > a.size

    [true, false]
  end
end

packet_pairs = input_string.split("\n\n")
index_sum = 0
packet_pairs.each_with_index do |packet_pair, index|
  left, right = packet_pair.split("\n").collect { |packet| JSON.parse(packet) }
  puts "Comparing #{left} and #{right}..."
  result, = check_pair(left, right)
  puts result
  index_sum += index + 1 if result
  puts '--------------------------------------'
end
puts index_sum

packets = input_string.split("\n").reject(&:empty?).collect { |p| JSON.parse(p) }
puts packets.inspect
packets.sort! { |p1, p2| check_pair(p1, p2)[0] ? -1 : 1 }

puts packets.inspect
puts (packets.index([[2]]) + 1) * (packets.index([[6]]) + 1)
