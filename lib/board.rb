require 'require_all'
require_all './pieces'

class Board
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

  def self.create_grid
    grid = Array.new(8) { Array.new(8) }
    grid.each_with_index do |row, row_idx|
      row.each_with_index do |column, column_idx|
        grid[row_idx][column_idx] = NullPiece.instance
      end
    end
  end

  attr_reader :grid
  attr_accessor :start_pos

  def initialize
    @grid = Board.create_grid
    @start_pos = nil
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

  def in_bounds?(pos)
    pos.all? { |coord| coord.between?(0, 7)}
  end

  def space_available?(current_piece, new_pos)
    space_empty?(new_pos) || space_occupied_by_opponent?(current_piece, new_pos)
  end

  def space_empty?(pos)
    self[pos].type == :nullpiece
  end

  def space_occupied_by_opponent?(current_piece, new_pos)
    other_piece = self[new_pos]
    (current_piece.color == :black && other_piece.color == :white) ||
    (current_piece.color == :white && other_piece.color == :black)
  end

  # to check for valid pawn move
  def diagonal?(start_pos, end_pos)
    ((start_pos[0] - end_pos[0]).abs == 1) && ((start_pos[1] - end_pos[1]).abs == 1) && self.space_occupied_by_opponent?(self[start_pos], end_pos)
  end

  # to check for valid pawn move
  def two_ahead?(start_pos, end_pos)
    one_space_ahead = [((start_pos[0] + end_pos[0]) / 2), start_pos[1]]
    (start_pos[0] - end_pos[0]).abs == 2 && self.space_empty?(end_pos) && self.space_empty?(one_space_ahead)
  end

  # to check for valid pawn move
  def one_ahead?(start_pos, end_pos)
    (start_pos[0] - end_pos[0]).abs == 1 && (start_pos[1] - end_pos[1]).abs == 0 && self.space_empty?(end_pos)
  end

  def valid_start_pos?(pos, player_color)
    # pos may be nil because of cursorable.rb:47, moving will return nil
    return false if pos.nil?
    piece = self[pos]
    piece.color == player_color && !piece.moves(self, pos).empty?
  end

  def valid_end_pos?(pos)
    return false if pos.nil?
    piece = self[@start_pos]
    piece.moves(self, @start_pos).include?(pos)
  end

  def move_piece(start_pos, end_pos)
    piece = self[start_pos]
    self[start_pos] = NullPiece.instance
    self[end_pos] = piece
  end

  def flatten
    @grid.flatten
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
