# frozen_string_literal: true

input_string = nil
File.open 'input/day07_input.txt' do |puzzle_in|
  input_string = puzzle_in.read
end

# input_string = "$ cd /
# $ ls
# dir a
# 14848514 b.txt
# 8504156 c.dat
# dir d
# $ cd a
# $ ls
# dir e
# 29116 f
# 2557 g
# 62596 h.lst
# $ cd e
# $ ls
# 584 i
# $ cd ..
# $ cd ..
# $ cd d
# $ ls
# 4060174 j
# 8033020 d.log
# 5626152 d.ext
# 7214296 k"

dirtree = {}
mode = nil
current_dir = dirtree
hierarchy = [dirtree]
input_string.split("\n").each do |line|
  if /^\$/ =~ line
    _, command, *dir = line.split
    if command == 'ls'
      mode = :ls
    elsif command == 'cd'
      mode = :cd
      # puts "Moving to #{dir}"
      if dir == ['..']
        current_dir = hierarchy.pop
      elsif dir == ['/']
        current_dir = dirtree
        hierarchy = [dirtree]
      else
        hierarchy.push(current_dir)
        current_dir = current_dir[dir.first]
      end
    end
  elsif mode == :ls
    # puts "Listing contents of #{hierarchy[-1]}"
    size_type, name = line.split
    # puts "Writing #{name} [#{size_type}] to #{current_dir}"
    current_dir[name] ||= if size_type == 'dir'
                            {}
                          else
                            size_type.to_i
                          end
  end
end

File.write('day07_out.json', dirtree)
# puts dirtree
dirs = []
def recursive_get_size(node, dirs)
  node.sum do |_key, value|
    if value.is_a?(Hash)
      size = recursive_get_size(value, dirs)
      dirs.push(size)
      size
    else
      value.to_i
    end
  end
end

total_used = recursive_get_size(dirtree, dirs)

puts dirs.select { |v| v <= 100_000 }.sum

total_space = 70_000_000
needed_space = 30_000_000

to_free = needed_space - (total_space - total_used)

puts dirs.select { |v| v >= to_free }.min
