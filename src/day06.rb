# frozen_string_literal: true

input_string = nil
File.open 'input/day06_input.txt' do |puzzle_in|
  input_string = puzzle_in.read
end

# input_string = "bvwbjplbgvbhsrlpgdmjqwftvncz"
def first_unique_sequence_of(n, string)
  stack = string.chars[...n]
  string.chars[n..].each_with_index do |char, index|
    if stack.uniq == stack
      puts index + n
      break
    end
    stack.push(char)
    stack.shift
  end
end

first_unique_sequence_of(4, input_string)
first_unique_sequence_of(14, input_string)
