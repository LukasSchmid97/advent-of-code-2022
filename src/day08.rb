# frozen_string_literal: true

input_string = nil
File.open 'input/day08_input.txt' do |puzzle_in|
  input_string = puzzle_in.read
end

# input_string = "30373
# 25512
# 65332
# 33549
# 35390"

grid = input_string.split("\n").collect {|s| s.chars.collect(&:to_i)}
vis_map = grid.dup.collect { |a| a.dup.collect {0}}

# rows
num_rows = grid.size
num_cols = grid.first.size


max_row = Array.new(num_rows, -1)
# from left
grid.each_with_index do |col, col_index|
  col.each_with_index do |row_value, row_index|
    if grid[col_index][row_index] > max_row[col_index]
      vis_map[col_index][row_index] = 1
      max_row[col_index] = grid[col_index][row_index]
    end
  end
end

max_row = Array.new(num_rows, -1)
# from right
grid.each_with_index do |col, col_index|
  col.each_with_index do |row_value, row_index|
    if grid[col_index][-row_index-1] > max_row[col_index]
      vis_map[col_index][-row_index-1] = 1
      max_row[col_index] = grid[col_index][-row_index-1]
    end
  end
end

max_col = Array.new(num_cols, -1)
# from top
grid.each_with_index do |col, col_index|
  col.each_with_index do |row_value, row_index|
    if grid[row_index][col_index] > max_col[col_index]
      vis_map[row_index][col_index] = 1
      max_col[col_index] = grid[row_index][col_index]
    end
  end
end

max_col = Array.new(num_cols, -1)
# from bot
grid.each_with_index do |col, col_index|
  col.each_with_index do |row_value, row_index|
    if grid[-row_index-1][col_index] > max_col[col_index]
      vis_map[-row_index-1][col_index] = 1
      max_col[col_index] = grid[-row_index-1][col_index]
    end
  end
end

puts vis_map.sum(&:sum)

vis_map = grid.dup.collect { |a| a.dup.collect { 1 } }

# O(4n^2)

def tree_distances(row)
  # O(nk), where k == tree_height
  seen_heights = Array.new(10, 0)
  distances = []
  row.each_with_index do |tree_height, index|
    distances[index] = index - seen_heights[tree_height]
    seen_heights[0..tree_height] = Array.new(tree_height + 1, index)
  end
  distances
end

# do cols
grid.each_with_index do |col, col_index|
  tree_distances(col).each_with_index do |dist, row_index|
    vis_map[col_index][row_index] *= dist
  end
  tree_distances(col.reverse).each_with_index do |dist, row_index|
    vis_map[col_index][-row_index-1] *= dist
  end
end

# do rows
grid[0].zip(*grid[1..]).each_with_index do |col, col_index|
  tree_distances(col).each_with_index do |dist, row_index|
    vis_map[row_index][col_index] *= dist
  end
  tree_distances(col.reverse).each_with_index do |dist, row_index|
    vis_map[-row_index-1][col_index] *= dist
  end
end

puts vis_map.collect(&:max).max
