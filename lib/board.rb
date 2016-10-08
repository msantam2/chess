require 'require_all'
require 'deep_clone'
require_all 'pieces'

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
      row.each_with_index do |col, col_idx|
        grid[row_idx][col_idx] = NullPiece.instance
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

  def space_available?(current_piece, end_pos)
    space_empty?(end_pos) || space_occupied_by_opponent?(current_piece, end_pos)
  end

  def space_empty?(pos)
    self[pos].type == :nullpiece
  end

  def space_occupied_by_opponent?(current_piece, end_pos)
    other_piece = self[end_pos]
    (current_piece.color == :black && other_piece.color == :white) ||
    (current_piece.color == :white && other_piece.color == :black)
  end

  # to check for valid pawn move:
  # remember, a pawn can only move up diagonally one space if
  # it is capturing an opponent. This method #diagonal?
  # checks if the potential end space is indeed one move up and
  # diagonal, and is occupied by an opponent, i.e.
  # (diagonal space? && there is an opponent there).
  def diagonal?(start_pos, end_pos)
    ((start_pos[0] - end_pos[0]).abs == 1) && ((start_pos[1] - end_pos[1]).abs == 1) && self.space_occupied_by_opponent?(self[start_pos], end_pos)
  end

  # to check for valid pawn move
  # one_ahead? checks if the potential end_pos is indeed
  # one space forward from the pawn and if it is empty.
  def one_ahead?(start_pos, end_pos)
    (start_pos[0] - end_pos[0]).abs == 1 && (start_pos[1] - end_pos[1]).abs == 0 && self.space_empty?(end_pos)
  end

  # to check for valid pawn move:
  # #two_ahead? is called if the pawn is on its first move,
  # and according to the rules of chess can move either one OR
  # two moves forward (only if both are empty, i.e. it cannot
  # move 2 spaces by jumping over 1). #two_ahead? checks three
  # things:
  # the potential end_pos is indeed 2 spaces forward &&
  # this space 2 forward is empty && the space 1 forward is also
  # empty.
  def two_ahead?(start_pos, end_pos)
    one_space_ahead = [((start_pos[0] + end_pos[0]) / 2), start_pos[1]]
    (start_pos[0] - end_pos[0]).abs == 2 && self.space_empty?(end_pos) && self.space_empty?(one_space_ahead)
  end

  def valid_start_pos?(pos, player)
    # pos may be nil because of cursorable.rb:47, moving will return nil
    return false if pos.nil?
    piece = self[pos]
    piece.color == player.color && !piece.moves(self, pos).empty?
  end

  def in_check?(player)
    king_pos = king_pos(player.color)
    opponent = opponent_color(player.color)
    player_moves(opponent).values.flatten(1).include?(king_pos)
    # player_moves returns a hash of the following
    # structure (key = start_pos, value = all
    # possible end positions)...which piece it
    # is does not matter:
    # {[1, 2] => [[1, 4], [2, 3]],
    #  [3, 7] => [[3, 8], [4, 6]]}
    # when calling .values,
    # [[[1, 4], [2, 3]], [[3, 8], [4, 6]]] is returned
    # we need flatten once with flatten(1) in order
    # to check if the king_pos is included
  end

  def in_checkmate?(player)
    # you already know you are in check, so current king_pos is in check already. look at all of player's possible moves and see if all of them keep him in a state of check
    current_player_moves = player_moves(player.color)
    # start_pos = [4, 5]
    # end_positions = [[4, 6], [5, 5]]
    # ^ end_positions represents all the moves that can
    # be made FROM the start_pos
    current_player_moves.each do |start_pos, end_positions|
      end_positions.each do |end_pos|
        new_board = DeepClone.clone(self)
        new_board.move_piece(start_pos, end_pos)
        return false if !new_board.in_check?(player)
      end
    end

    true
  end

  def opponent_color(player_color)
    player_color == :black ? :white : :black
  end

  def player_moves(player_color)
    player_pieces = player_pieces(player_color)

    moves = {}
    player_pieces.each do |piece, pos|
      moves[pos] = piece.moves(self, pos)
    end
    moves
    # moves is a hash, where the key is the start_pos
    # and the value is all the moves that can be made
    # from that start_pos.
    # the reason for this structure is mainly for
    # #in_checkmate? the board must make the move
    # from the start_pos to each end_pos and
    # evaluate if player is still in check
  end

  def player_pieces(player_color)
    pieces_with_positions = {}

    @grid.each_with_index do |row, row_idx|
      row.each_index.each do |col_idx|
        pos = [row_idx, col_idx]
        if self[pos].color == player_color
          pieces_with_positions[self[pos]] = pos
        end
      end
    end
    # pieces_with_positions looks like the following:
    # {<KingObject>: [3, 4], <KnightObject>: [0, 4],
    #  <PawnObject>: [2, 6]}. All keys are pieces that
    # belong to 'player_color' and they point to their
    # current position on the board
    pieces_with_positions
  end

  def king_pos(player_color)
    @grid.each_with_index do |row, row_idx|
      row.each_index do |col_idx|
        pos = [row_idx, col_idx]
        if self[pos].type == :king && self[pos].color == player_color
          return pos
        end
      end
    end
  end

  def valid_end_pos?(pos)
    return false if pos.nil?
    piece = self[@start_pos]
    piece.moves(self, @start_pos).include?(pos)
  end

  def move_piece(start_pos, end_pos)
    piece = self[start_pos]
    end_piece = self[end_pos]

    self[start_pos] = NullPiece.instance
    self[end_pos] = piece

    # returning this value to Game#move_piece in order to annouce what piece has been captured
    end_piece
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
