input_string = nil
File.open 'input/day05_input.txt' do |puzzle_in|
  input_string = puzzle_in.read
end

# input_string = <<~INPUT
#       [D]#{'    '}
#   [N] [C]#{'    '}
#   [Z] [M] [P]
#    1   2   3

#   move 1 from 2 to 1
#   move 3 from 1 to 3
#   move 2 from 2 to 1
#   move 1 from 1 to 2
# INPUT

def print_stacks(stack)
  max_height = stack.collect(&:size).max
  max_height.times do |index|
    stack.each do |boxes|
      stack_item = boxes[max_height - 1 - index]
      if stack_item.nil?
        print "    "
      else
        print "[" + stack_item + "] "
      end
    end
    puts ""
  end
  stack.count.times do |index|
    print " #{index + 1}  "
  end
  puts ""
end

start_layout, moves = input_string.split("\n\n")

## stacks
stack_count = start_layout.split("\n").last.chars.collect(&:to_i).max
reverse_stacks = []
stack_count.times { reverse_stacks.push([])}
start_layout.split("\n").each do |line|
  next unless /[[:alpha:]]/ =~ line

  line.chars.each_slice(4).collect(&:join).each_with_index do |slice, position|
    if slice.strip.empty?
      reverse_stacks[position].push(nil)
    else
      reverse_stacks[position].push(/\[(\w)\]/.match(slice)[1])
    end
  end
end
stacks = reverse_stacks.collect(&:reverse).collect(&:compact)
print_stacks(stacks)

prob_1_stacks = stacks.collect(&:dup)
prob_2_stacks = stacks.collect(&:dup)
### moves
move_box = ->(num, source, target, crane) { target.push(*crane.call(source.pop(num))) }
moves.split("\n").each do |move|
  matches = /\D*(\d+)\D*(\d+)\D*(\d+)\D*/.match(move)
  num, start, target = matches[1].to_i, matches[2].to_i, matches[3].to_i
  move_box.call(num, prob_1_stacks[start-1], prob_1_stacks[target-1], ->(arr){arr.reverse})
  move_box.call(num, prob_2_stacks[start-1], prob_2_stacks[target-1], ->(arr){arr})
  puts "Moving #{num} boxes from #{start} to #{target}..."
  print_stacks(prob_2_stacks)
end

puts "Solution 1"
puts prob_1_stacks.collect(&:last).join

####### part 2
#
puts "Solution 2"
puts prob_2_stacks.collect(&:last).join
