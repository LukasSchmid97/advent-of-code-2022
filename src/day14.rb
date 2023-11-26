# frozen_string_literal: true

input_string = nil
File.open 'input/day14_input.txt' do |puzzle_in|
  input_string = puzzle_in.read
end

# input_string = "498,4 -> 498,6 -> 496,6
# 503,4 -> 502,4 -> 502,9 -> 494,9"

SAND_SOURCE = [500, 0].freeze
map = 1000.times.collect do
  1000.times.collect { false }
end

STRUCTURAL_LINES = input_string.split("\n").collect do |line|
  line.split(' -> ').collect do |coord|
    coord.split(',').collect(&:to_i)
  end
end

STRUCTURAL_LINES.each do |line|
  last_y = nil
  last_x = nil
  last_coord = line.first
  # puts "Parsing #{line}"
  line[1..].each do |next_coord|
    start_x, end_x = [last_coord.first, next_coord.first].sort
    start_y, end_y = [last_coord.last, next_coord.last].sort
    # puts "Drawing line from #{start_x}, #{end_x} to #{start_y}, #{end_y} "
    x_arr = (start_x..end_x)
    y_arr = (start_y..end_y)
    if x_arr.size == 1
      x_arr = y_arr.size.times.collect { start_x }
    elsif y_arr.size == 1
      y_arr = x_arr.size.times.collect { start_y }
    end
    x_arr.zip(y_arr).each do |x, y|
      map[y || last_y][x || last_x] = true
    end
    last_coord = next_coord
  end
end

MAX_Y = map.each_with_index.select { |row, _| row.any? }.last[1]
# puts(map.each_with_index.select { |row, _| row.any? }.inspect)

def drop_sand(map)
  sand_position = SAND_SOURCE
  sand_rest_position = nil, nil
  loop do
    y_offset = 1
    [0, -1, 1].each do |x_offset|
      new_y = sand_position.last + y_offset
      new_x = sand_position.first + x_offset
      if new_y >= map.size
        sand_rest_position = sand_position = nil
        break
      end
      unless map[new_y][new_x]
        sand_position = [new_x, new_y]
        break
      end
    end
    break if sand_position == sand_rest_position

    sand_rest_position = sand_position
  end
  # puts "Resting at #{sand_rest_position}"
  sand_rest_position
end

puts STRUCTURAL_LINES.inspect
total_sand = 0
loop do
  sand_coords = drop_sand(map)
  break if sand_coords.nil?

  map[sand_coords.last][sand_coords.first] = true
  total_sand += 1
end

puts 'Without floor:'
puts total_sand

1000.times do |index|
  map[MAX_Y + 2][index] = true
end

loop do
  sand_coords = drop_sand(map)

  map[sand_coords.last][sand_coords.first] = true
  total_sand += 1
  break if sand_coords == [500, 0]
end

puts 'With floor:'
puts total_sand
