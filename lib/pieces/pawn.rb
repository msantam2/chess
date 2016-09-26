require_relative 'stepable'
require_relative 'piece'

class Pawn < Piece
  include Stepable

  def move_directions
    # [:down, :down]/[:up, :up] options for first move of the pawn
    if self.color == :black
      [[:down, :down], :down, :left_down, :right_down]
    else
      [[:up, :up], :up, :left_up, :right_up]
    end
  end

  def pawn_moves(start_pos, board, moves)
    filtered_moves = []

    moves.each do |move|
      if valid_pawn_move?(start_pos, board, move)
        filtered_moves << move
      end
    end

    filtered_moves
  end

  def valid_pawn_move?(start_pos, board, move)
    board.diagonal?(start_pos, move) ||
    (first_move(start_pos) && board.two_ahead?(start_pos, move)) ||
    board.one_ahead?(start_pos, move)
  end

  def first_move(start_pos)
    (self.color == :black && start_pos[0] == 1) ||
    (self.color == :white && start_pos[0] == 6)
  end
end
