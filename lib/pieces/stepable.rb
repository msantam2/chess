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
      new_pos = start_pos.dup
      if move_direction.is_a?(Array)
        move_direction.each do |move_dir|
          current_delta = DIRECTION_DELTAS[move_dir]
          new_pos[0] += current_delta[0]; new_pos[1] += current_delta[1]
        end
      else
        delta = DIRECTION_DELTAS[move_direction]
        new_pos[0] += delta[0]; new_pos[1] += delta[1]
      end

      all_moves << new_pos if valid_move?(board, new_pos)
    end

    self.type == :pawn ? pawn_moves(start_pos, board, all_moves) : all_moves
  end

  def valid_move?(board, new_pos)
    board.in_bounds?(new_pos) && board.space_available?(self, new_pos)
  end
end
