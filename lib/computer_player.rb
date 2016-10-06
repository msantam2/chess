require_relative 'player'
require 'require_all'
require_all 'pieces'

class ComputerPlayer < Player
  def get_move(display) # display.board to access the board
    if display.board.start_pos.nil?
      select_start_pos(display.board)
    else
      select_end_pos(display.board)
    end
  end

  def select_start_pos(board)
    sleep(1)
    if board.in_check?(self)
      # check to see if comp is strictly in check OR is, in fact, in checkmate. If comp is not in check, they cannot be in checkmate. This way, there is not an expensive check on each turn for checkmate status. Checkmate is only checked if the player is in check. This is the reason for this nested conditional.
      if board.in_checkmate?(self)
        #make random move

      else # still only in check, not checkmate
        # move out of check

      end
    end
      # will not move INTO check/checkmate
    # elsif can induce check/checkmate
      # moves to force opponent into check/checkmate
    # elsif has the ability to make a high value capture
      # makes the highest value capture
    # else
      # makes a random move
    # end

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
