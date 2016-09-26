require './player'
require 'require_all'
require_all './pieces'

class ComputerPlayer < Player
  def get_move(display)
    if display.board.start_pos.nil?
      select_start_pos(display.board)
    else
      select_end_pos(display.board)
    end
  end

  def select_start_pos(board)
    sleep(1)
    possible_positions = []

    board.grid.each_with_index do |row, row_idx|
      row.each_index do |col_idx|
        current_pos = [row_idx, col_idx]
        if board.valid_start_pos?(current_pos, self.color)
          possible_positions << current_pos
        end
      end
    end

    possible_positions.sample
  end

  def select_end_pos(board)
    sleep(1)
    piece = board[board.start_pos]
    piece.moves(board, board.start_pos).sample
  end
end
