

class Grid
  attr_reader :width, :height

  def initialize(width, height)
    @width, @height = width, height
    @grid = []
    height.times { @grid << Array.new(width)}
    @free_row_for_column = Array.new(@width, @height - 1)
  end
  
  def move(player, column)
    if column < 0 || column > @width - 1
      raise "bad column"
    end
    
    first_free_row(column)[column] = player
    @free_row_for_column[column] -= 1
  end
  
  def first_free_row(column)
    @grid[@free_row_for_column[column]]
  end
  
  def is_finished?
    @grid.each do |row|
      row_string = row.join("")
      if row_string.include?("XXXX") or
        row_string.include?("OOOO")
        return true
      end
    end

  @grid.transpose.each do |column|
      column_string = column.join("")
      if column_string.include?("XXXX") or
        column_string.include?("OOOO")
        return true
      end
    end

    false
  end
  
  def to_s
    @grid.map do |row| 
      row.map {|cell| render_cell(cell)}.join
    end.join("\n") + "\n"
  end
  
  def render_cell(cell)
    return '.' unless cell
    cell
  end
end


if __FILE__ == $0
  require "test/unit"
  
  class GridTest < Test::Unit::TestCase
    def test_initialize
      grid = Grid.new(7, 6)
      assert_equal 7, grid.width
      assert_equal 6, grid.height
    end
    
    def test_display_blank_board
      grid = Grid.new(7, 6)
      assert_equal grid.to_s, <<-BOARD
.......
.......
.......
.......
.......
.......
      BOARD
    end

    def test_display_blank_board
      grid = Grid.new(2, 3)
      assert_equal grid.to_s, <<-BOARD
..
..
..
      BOARD
    end

    def test_make_move
      grid = Grid.new(7, 6)
      grid.move("X", 0)
      assert_equal grid.to_s, <<-BOARD
.......
.......
.......
.......
.......
X......
      BOARD
      
    end
    
    def test_stack
      grid = Grid.new(7, 6)
      grid.move("X", 2)
      grid.move("O", 2)
      assert_equal grid.to_s, <<-BOARD
.......
.......
.......
.......
..O....
..X....
      BOARD
    end
    
    def test_off_edge_of_board
      grid = Grid.new(2, 3)
      assert_raise(RuntimeError) { grid.move("X", -1) }
      assert_raise(RuntimeError) { grid.move("X", 10000) }
    end
    
    def test_finished_horizontally
      grid = Grid.new(7, 6)
      grid.move("X", 0)
      grid.move("X", 1)
      grid.move("X", 2)
      assert !grid.is_finished?
      grid.move("X", 3)
      assert grid.is_finished?
    end

    def test_finished_vertically
      grid = Grid.new(7, 6)
      grid.move("X", 0)
      grid.move("X", 0)
      grid.move("X", 0)
      assert !grid.is_finished?
      grid.move("X", 0)
      assert grid.is_finished?
    end
  end
end








