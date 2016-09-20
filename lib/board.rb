class Board
  def self.create_grid
    grid = Array.new(8) { Array.new(8) }
    grid.each_with_index do |row, row_idx|
      row.each_with_index do |column, column_idx|
        grid[row_idx][column_idx] = 'X'
      end
    end
  end

  attr_reader :grid

  def initialize
    @grid = Board.create_grid
  end

  def on_board?(pos)
    
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, val)
    row, col = pos
    @grid[row][col] = val
  end
end
