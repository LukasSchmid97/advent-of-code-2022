# frozen_string_literal: true

require 'yaml'

input_string = nil
File.open 'input/day10_input.txt' do |puzzle_in|
  input_string = puzzle_in.read
end

thing = YAML.load_file('some.yml')
puts thing.inspect
