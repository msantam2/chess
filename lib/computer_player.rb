require_relative 'player'
require 'ruby_deep_clone'
require 'require_all'
require_all 'pieces'

class ComputerPlayer < Player
  # most common assignment of point values in modern day chess. The
  # king is typically not assigned a point value as it never is
  # technically involved in an exchange. Here it is assigned a point
  # value of 10 so the computer knows it is the most valuable.
  RELATIVE_PIECE_VALUES = {
    pawn: 1,
    knight: 3,
    bishop: 3,
    rook: 5,
    queen: 9,
    king: 10
  }

  def initialize
    @end_pos = nil
  end

  def get_move(display)
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
        random_start_pos(board)
      else # still only in check, NOT checkmate
        avoid_check_start_pos(board)
      end
    else # computer is not in check or checkmate. choose normal move.
      free_start_pos(board)
    end
  end

  # method to choose start_pos when neither in check nor checkmate
  def free_start_pos(board)
    start_positions = possible_start_positions(board)
    induce_check_filter(start_positions)
  end

  def possible_start_positions(board)
    start_positions = []

    board.grid.each_with_index do |row, row_idx|
      row.each_index do |col_idx|
        current_pos = [row_idx, col_idx]
        if board.valid_start_pos?(current_pos, self)
          start_positions << current_pos
        end
      end
    end

    start_positions
  end

  def avoid_check_start_pos(board)
    start_positions = []

    possible_start_positions(board).each do |start_pos|
      piece = board[start_pos]
      possible_end_positions = piece.moves(board, start_pos)
      possible_end_positions.each do |end_pos|
        new_board = DeepClone.clone(board)
        new_board.move_piece(start_pos, end_pos)
        unless new_board.in_check?(self)
          start_positions << start_pos
          # for now we only need start_pos with at least one move that
          # will avoid check. So, for each start_pos, once we confirm
          # there is at least one move to avoid check, we can 'break'.
          break
        end
      end
    end

    induce_check_filter(start_positions)
  end

  # this method will take an array of moves and if any of the moves can
  # force the computer's opponent into check/checkmate, it will choose
  # this move.
  def induce_check_filter(start_positions)
    filtered_moves = []

    start_positions.each do |start_pos|
      
    end

    higher_value_capture_filter(filtered_moves)
  end

  # this method will evaluate if the computer has more than one capture
  # opportunity available. If so, it will capture the piece with the
  # 'highest value', i.e. computer will take a queen over a pawn.
  def higher_value_capture_filter(start_positions)
    filtered_moves = []



    filtered_moves
  end

  def random_start_pos(board)
    possible_start_positions(board).sample
  end

  def select_end_pos(board)
    sleep(1)
    if @end_pos
      current_end_pos = @end_pos
      @end_pos = nil
      current_end_pos
    else
      piece = current_piece(board)
      piece.moves(board, board.start_pos).sample
    end
  end

  def current_piece
    board[board.start_pos]
  end

  def other_player
    self.color == :black ? :white : :black
  end
end
