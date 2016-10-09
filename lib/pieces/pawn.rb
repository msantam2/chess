require_relative 'stepable'
require_relative 'piece'

class Pawn < Piece
  include Stepable

  # every possible direction is included in #move_directions,
  # and based off the current board and whether it's the pawn's first
  # move, all of these moves are filtered down in #pawn_moves
  def move_directions
    # [:down, :down]/[:up, :up] options for first move of the pawn
    if self.color == :black
      [[:down, :down], :down, :left_down, :right_down]
    else
      [[:up, :up], :up, :left_up, :right_up]
    end
  end

  # #pawn_moves filters down the possible pawn moves based off the
  # current board and whether or not it is the pawn's first move
  def pawn_moves_filter(start_pos, board, moves)
    pawn_moves = []

    moves.each do |move|
      if valid_pawn_move?(start_pos, board, move)
        pawn_moves << move
      end
    end

    pawn_moves
  end

  # #valid_pawn_move? checks for 3 conditions to see if a pawn move is
  # valid:
  # (in order within the logical || operators):
  # 1. an opponent is located immediately diagonally of the pawn,
  # allowing the pawn to capture this piece OR
  # 2. the pawn is on its first move and the 2 spaces immiediately
  # in front of it are empty OR
  # 3. the space directly in front of the is empty and NOT occupied
  # by an opponent.
  def valid_pawn_move?(start_pos, board, move)
    board.diagonal?(start_pos, move) ||
    (first_move(start_pos) && board.two_ahead?(start_pos, move)) ||
    board.one_ahead?(start_pos, move)
  end

  # #first_move checks to see if a pawn is still at its starting
  # position, allowing it to move up TWO spaces on its first move.
  def first_move(start_pos)
    (self.color == :black && start_pos[0] == 1) ||
    (self.color == :white && start_pos[0] == 6)
  end
end
