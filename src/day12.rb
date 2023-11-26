# frozen_string_literal: true

input_string = nil
File.open 'input/day12_input.txt' do |puzzle_in|
  input_string = puzzle_in.read
end

# input_string = "Sabqponm
# abcryxxl
# accszExk
# acctuvwj
# abdefghi"

MAP = input_string.split("\n").collect { |string| string.chars.collect(&:ord) }
unseen_tiles = MAP.collect { |l| l.collect { true } }

start = 'S'
goal = 'E'
posy_s = -1
posx_s = MAP.index { |letter_list| posy_s = letter_list.index { |letter| letter == start.ord } }
unseen_tiles[posx_s][posy_s] = false
queue = []
queue.push([posx_s, posy_s, 0])

def map_to_string(matrix)
  matrix.collect(&:join).join("\n")
end

def seen_to_s
  map_to_string(unseen_tiles.collect { |row| row.collect { |e| e ? 1 : 0 } })
end

until queue.empty?
  x, y, depth = queue.pop
  if MAP[x][y] == goal.ord
    puts 'FOUND IT'
    # puts seen_to_s
    puts depth
    break
  else
    current_letter_index = MAP[x][y]
    current_letter_index = 96 if MAP[x][y] == 'S'.ord
    # puts "Looking at character #{current_letter_index.chr} at depth #{depth}"
    # DO NOT DO DEPTH FIRST; USE LOOP AND queue
    (-1..1).each do |x_mod|
      (-1..1).each do |y_mod|
        next unless x_mod == 0 || y_mod == 0
        next unless unseen_tiles[x + x_mod] && unseen_tiles[x + x_mod][y + y_mod] && x + x_mod >= 0 && y + y_mod >= 0

        next_is_steppable = MAP[x + x_mod][y + y_mod] <= 1 + current_letter_index && MAP[x + x_mod][y + y_mod] > 90
        next_is_end = MAP[x + x_mod][y + y_mod] == goal.ord
        is_final_step = current_letter_index.chr == 'z'
        next unless next_is_steppable || (next_is_end && is_final_step)

        # puts "Saw character #{current_letter_index.chr} at depth #{depth}"
        # puts seen_to_s
        unseen_tiles[x + x_mod][y + y_mod] = false
        queue.unshift([x + x_mod, y + y_mod, depth + 1])
      end
    end
  end
end

# locate S
# starting at S, populate with distance recursively
#   stop if letter.ord > 1 + current_letter.ord || !unseen[cur_x][cur_y]

### PART 2 ###3
start = 'E'
goal = 'a'
unseen_tiles = MAP.collect { |l| l.collect { true } }
posy_s = -1
posx_s = MAP.index { |letter_list| posy_s = letter_list.index { |letter| letter == start.ord } }
queue = []
queue.push([posx_s, posy_s, 0])

until queue.empty?
  x, y, depth = queue.pop
  if MAP[x][y] == goal.ord
    puts 'FOUND IT'
    # puts seen_to_s
    puts depth
    break
  else
    current_letter_index = MAP[x][y]
    current_letter_index = 123 if MAP[x][y] == 'E'.ord
    # puts "Looking at character #{current_letter_index.chr} at depth #{depth}"
    # DO NOT DO DEPTH FIRST; USE LOOP AND queue
    (-1..1).each do |x_mod|
      (-1..1).each do |y_mod|
        next unless x_mod == 0 || y_mod == 0
        next unless unseen_tiles[x + x_mod] && unseen_tiles[x + x_mod][y + y_mod] && x + x_mod >= 0 && y + y_mod >= 0

        next_is_steppable = MAP[x + x_mod][y + y_mod] >= current_letter_index - 1 && MAP[x + x_mod][y + y_mod] > 90
        next unless next_is_steppable # || (next_is_end && is_final_step)

        # puts "Saw character #{current_letter_index.chr} at depth #{depth}"
        # puts seen_to_s
        unseen_tiles[x + x_mod][y + y_mod] = false
        queue.unshift([x + x_mod, y + y_mod, depth + 1])
      end
    end
  end
end
