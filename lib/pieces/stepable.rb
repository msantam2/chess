module Stepable
  DIRECTION_DELTAS = {
    up: [-1, 0],
    down: [1, 0],
    left: [0, -1],
    right: [0, 1],
    left_up: [-1, -1],
    right_up: [-1, 1],
    left_down: [1, -1],
    right_down: [1, 1]
  }

  def moves(board, start_pos)
    all_moves = []

    move_directions.each do |move_direction|
      end_pos = start_pos.dup
      if move_direction.is_a?(Array)
        move_direction.each do |move_dir|
          current_delta = DIRECTION_DELTAS[move_dir]
          end_pos[0] += current_delta[0]; end_pos[1] += current_delta[1]
        end
      else
        delta = DIRECTION_DELTAS[move_direction]
        end_pos[0] += delta[0]; end_pos[1] += delta[1]
      end

      all_moves << end_pos if valid_move?(board, end_pos)
    end
    # since the pawn has quite unique behavior, it must have its own
    # #pawn_moves method, which is the reason for the ternary below.
    # if the piece is a pawn, defer to #pawn_moves (in ./pawn.rb),
    # otherwise, return all_moves.
    self.type == :pawn ? pawn_moves_filter(start_pos, board, all_moves) : all_moves
  end

  def valid_move?(board, end_pos)
    board.in_bounds?(end_pos) && board.space_available?(self, end_pos)
  end
end
