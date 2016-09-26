module Slideable
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
      delta = DIRECTION_DELTAS[move_direction]
      new_pos = [start_pos[0] + delta[0], start_pos[1] + delta[1]]

      while valid_move?(board, new_pos)
        all_moves << new_pos
        break if board.space_occupied_by_opponent?(self, new_pos)
        new_pos = [new_pos[0] + delta[0], new_pos[1] + delta[1]]
      end
    end

    all_moves
  end

  def valid_move?(board, new_pos)
    board.in_bounds?(new_pos) && board.space_available?(self, new_pos)
  end
end
