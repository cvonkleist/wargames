require 'ostruct'

$width, $height = 20, 20
maze = (0...$width).collect { (0...$height).collect { '#' } }

def putsi(indent, text)
  #indent = 0
  puts '  ' * indent + text
end

def display(maze, indent = 0)
  putsi indent, '-' * (maze.first.length + 2)
  maze.each do |row|
    putsi indent, '|' + row * '' + '|'
  end
  putsi indent, '-' * (maze.first.length + 2)
end

def occupied?(maze, position)
  maze[position.x][position.y] != '#' rescue false
end

def occupy!(maze, position, char = ' ')
  maze[position.x][position.y] = char[-1, 1]
end

def add(position, x_offset, y_offset)
  OpenStruct.new(:x => position.x + x_offset, :y => position.y + y_offset)
end

def out_of_bounds(position)
  position.x < 0 || position.y < 0 || position.x > max_x || position.y > max_y
end

def cause_cavein(maze, position)
  nine_around = [-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 0], [0, 1], [1, -1], [1, 0], [1, 1]
  nine_around.select { |offset| !out_of_bounds(position) && occupied?(maze, add(position, offset[0], offset[1])) }.length > 2
end

def copy_maze(source)
  (0...$width).collect { |x| (0...$height).collect { |y| source[x][y] } }
end


display maze

position = OpenStruct.new(:x => 0, :y => 1)

data = "KITCHENSINK".unpack("B*")[0].split('').collect { |c| c.to_i }

def max_x; $width - 1; end
def max_y; $height - 1; end

def find_way(maze, position, data, step = 1, indent = 0)
  if data == []
    $winning_maze = maze
    return true
  end

  data_head = data.first
  data_tail = data[1..-1]

  bit = data_head
  putsi indent, "bit = #{bit.inspect}"
  putsi indent, "data left = %d bits" % data.length
  moves = case bit
  when 0
    [add(position, -1, 0), add(position, 1, 0)]
  when 1
    [add(position, 0, -1), add(position, 0, 1)]
  end

  moves = moves.select { |m| !out_of_bounds(m) && !occupied?(maze, m) && !cause_cavein(maze, m) }
  if rand(2) == 0
    moves = moves.reverse
  end

  putsi indent, "moves = #{moves.inspect}"
  moves.each do |move|
    putsi indent, " move = #{move.inspect}"
    new_maze = copy_maze(maze)
    occupy! new_maze, move, ('%x' % step).to_s
    display new_maze, indent + 1
    return true if find_way new_maze, move, data_tail, step + 1, indent + 1
  end

  false
end


occupy! maze, position
puts find_way(maze, position, data)

puts "seed was #{srand}"
puts data * ''

display $winning_maze
