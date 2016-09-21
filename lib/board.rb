require 'require_all'
require_all './pieces'

class Board
  def self.create_grid
    grid = Array.new(8) { Array.new(8) }
    grid.each_with_index do |row, row_idx|
      row.each_with_index do |column, column_idx|
        grid[row_idx][column_idx] = NullPiece.instance
      end
    end
  end

  attr_reader :grid

  def initialize
    @grid = Board.create_grid
    populate_grid
  end

  def populate_grid
    set_royal_row(:black)
    set_pawn_row(:black)

    set_pawn_row(:white)
    set_royal_row(:white)
  end

  def set_pawn_row(color)
    row_idx = color == :black ? 1 : 6

    @grid[row_idx].map! { Pawn.new(:pawn, color) }
  end

  def set_royal_row(color)
    row_idx = color == :black ? 0 : 7

    @grid[row_idx].each_index do |col_idx|
      pos = [row_idx, col_idx]
      piece = ROYALS_ROW[col_idx]
      self[pos] = Object.const_get(piece.capitalize).new(piece.to_sym, color)
    end
  end

  ROYALS_ROW = [
    'rook',
    'knight',
    'bishop',
    'king',
    'queen',
    'bishop',
    'knight',
    'rook'
  ]

  def on_board?(pos)
    pos.all? { |coord| coord.between?(0, 7)}
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
