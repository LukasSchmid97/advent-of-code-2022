# frozen_string_literal: true

input_string = nil
File.open 'input/day1_input.txt' do |puzzle_in|
  input_string = puzzle_in.read
end

# input_string = "1000
# 2000
# 3000

# 4000

# 5000
# 6000

# 7000
# 8000
# 9000

# 10000"

elves = input_string.split("\n\n")
elves.collect! do |elf|
  elf.split("\n").collect(&:to_i).sum
end

puts elves.max
