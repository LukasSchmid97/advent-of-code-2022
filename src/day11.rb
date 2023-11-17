# frozen_string_literal: true

input_string = nil
File.open 'input/day11_input.txt' do |puzzle_in|
  input_string = puzzle_in.read
end

# input_string = "Monkey 0:
#   Starting items: 79, 98
#   Operation: new = old * 19
#   Test: divisible by 23
#     If true: throw to monkey 2
#     If false: throw to monkey 3

# Monkey 1:
#   Starting items: 54, 65, 75, 74
#   Operation: new = old + 6
#   Test: divisible by 19
#     If true: throw to monkey 2
#     If false: throw to monkey 0

# Monkey 2:
#   Starting items: 79, 60, 97
#   Operation: new = old * old
#   Test: divisible by 13
#     If true: throw to monkey 1
#     If false: throw to monkey 3

# Monkey 3:
#   Starting items: 74
#   Operation: new = old + 3
#   Test: divisible by 17
#     If true: throw to monkey 0
#     If false: throw to monkey 1"

get_last_num = ->(line) { line.split.last.to_i }

monkeys = {}
modulor = 1
input_string.split("\n\n").each do |monkey|
  monkey_lines = monkey.split("\n")
  modulor *= get_last_num.call(monkey_lines[3])
  monkeys[/\d/.match(monkey_lines[0])[0].to_i] = {
    items: monkey_lines[1].scan(/\d+/).to_a.collect(&:to_i),
    op: eval("->(old) { #{monkey_lines[2][19..]} }"),
    target: lambda { |value|
      (value % get_last_num.call(monkey_lines[3])).zero? ? get_last_num.call(monkey_lines[4]) : get_last_num.call(monkey_lines[5])
    },
    inspections: 0
  }
end

do_round = proc do
  monkeys.each do |_monkey_id, info|
    # puts "Monkey #{monkey_id} has items #{info[:items].inspect}"
    info[:items].each do |orig_worry|
      # inspect
      info[:inspections] += 1
      # puts "Monkey #{_monkey_id} inspects item with level #{orig_worry}"
      worry = info[:op].call(orig_worry) % modulor
      # worry /= 3
      target = info[:target].call(worry)
      # puts "Item with worry level #{worry} is thrown to monkey #{target}"
      monkeys[target][:items].push(worry)
    end
    info[:items].clear
    # puts '----'
  end
end

def print_monkey_items(monkeys)
  monkeys.each do |monkey_id, info|
    # puts "Monkey #{monkey_id}: #{info[:items].join(', ')}"
  end
  puts
end

10_000.times do |i|
  puts "Round #{i + 1}"
  do_round.call
  # print_monkey_items(monkeys)
end

inspects = monkeys.collect { |_, value| value[:inspections] }
puts inspects.sort[-2..].reduce(1) { |prod, num| prod * num }
