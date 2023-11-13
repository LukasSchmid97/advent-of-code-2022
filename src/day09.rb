# frozen_string_literal: true

input_string = nil
File.open 'input/day09_input.txt' do |puzzle_in|
  input_string = puzzle_in.read
end

# input_string = "R 4
# U 4
# L 3
# D 1
# R 4
# D 1
# L 5
# R 2"

c_add = ->(vec1, vec2) { [vec1[0] + vec2[0], vec1[1] + vec2[1]] }
c_inv = ->(vec) { [-vec[0], -vec[1]] }
c_sub = ->(vec1, vec2) { c_add.call(vec1, c_inv.call(vec2)) }
c_norm = ->(vec) { [vec[0] / [vec[0].abs, 1].max, vec[1] / [vec[1].abs, 1].max] }

head_coords = [0, 0]
tail_coords = [0, 0]
tail_coord_history = [[0, 0]]
input_string.split("\n").each do |move|
  dir, count = move.split
  count.to_i.times do
    case dir
    when 'U'
      vec = [0, 1]
    when 'D'
      vec = [0, -1]
    when 'L'
      vec = [-1, 0]
    when 'R'
      vec = [1, 0]
    end
    head_coords = c_add.call(head_coords, vec)
    dx, dy = c_sub.call(head_coords, tail_coords)
    next unless dx.abs > 1 || dy.abs > 1

    tail_vec = c_norm.call([dx, dy])
    tail_coords = c_add.call(tail_coords, tail_vec)
    tail_coord_history.push(tail_coords)
  end
end

puts tail_coord_history.uniq.count

head_coords = [0, 0]
tail_coords = 9.times.collect { [0, 0] }
tail_coord_history = [[0, 0]]
input_string.split("\n").each do |move|
  dir, count = move.split
  count.to_i.times do
    case dir
    when 'U'
      vec = [0, 1]
    when 'D'
      vec = [0, -1]
    when 'L'
      vec = [-1, 0]
    when 'R'
      vec = [1, 0]
    end
    head_coords = c_add.call(head_coords, vec)
    last_head_coord = head_coords
    tail_coords.each do |tail_coord|
      dx, dy = c_sub.call(last_head_coord, tail_coord)
      if dx.abs > 1 || dy.abs > 1
        tail_vec = c_norm.call([dx, dy])
        # puts "Moving tail #{index} from #{tail_coord} towards #{tail_vec}"
        tail_coord[0..2] = c_add.call(tail_coord, tail_vec)
      end
      last_head_coord = tail_coord
    end
    tail_coord_history.push(tail_coords[-1].dup)
  end
end

puts tail_coord_history.uniq.count
