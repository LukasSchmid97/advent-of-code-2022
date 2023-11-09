# frozen_string_literal: true

def win_score(player1, player2)
  if player2 - player1 == 1 || player2 - player1 == -2
    6
  elsif player1 == player2
    3
  else
    0
  end
end

def score(opponent_move, my_move)
  score = 0
  a_ = opponent_move.ord - 64
  b_ = my_move.ord - 23 - 64
  score += b_
  score += win_score(a_, b_)
  # puts "#{opponent_move} #{my_move} -> #{a_} #{b_} -> #{score}"
  score
end

def get_move_from_win(player1, desired_result)
  if desired_result == 'X'
    player1 == 1 ? 3 : player1 - 1
  elsif desired_result == 'Y'
    player1
  else
    (player1 % 3) + 1
  end
end

def score2(opponent_move, desired_result)
  score = 0
  a_ = opponent_move.ord - 64
  b_ = get_move_from_win(a_, desired_result)

  score += b_
  score + win_score(a_, b_)
  # puts "#{opponent_move} #{desired_result} -> #{a_} #{b_} -> #{score}"
end

File.open 'src/day2_input.txt' do |puzzle_in|
  input_arr = puzzle_in.read.split("\n").collect(&:split)

  part1 = input_arr.inject(0) { |sum, round| sum + score(*round) }
  puts part1

  part2 = input_arr.inject(0) { |sum, round| sum + score2(*round) }
  puts part2
end
