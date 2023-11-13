# frozen_string_literal: true

input_string = nil
File.open 'input/day10_input.txt' do |puzzle_in|
  input_string = puzzle_in.read
end

ops = input_string.split("\n")
total_sum = 0
memo = [1, 1]
process = proc do
  cursor = (memo[0] - 1) % 40
  print cursor == memo[1] + (cursor <=> memo[1]) ? '#' : '.'
  print "\n" if ((memo[0]) % 40).zero?
  total_sum += memo[0] * memo[1] if ((memo[0] - 20) % 40).zero?
  memo[0] += 1
end

ops.each do |value|
  if value == 'noop'
    process.call
  else
    2.times do
      process.call
    end
    memo[1] += value.split.last.to_i
  end
end

puts total_sum
