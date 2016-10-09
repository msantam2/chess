require_relative 'player'
require 'deep_clone'
require 'require_all'
require_all 'pieces'

class ComputerPlayer < Player
  # most common assignment of point values in modern day chess
  # (excluding :nullpiece).
  # does not include the king because in #induce_check_filter:98,
  # if there is a checkmate opportunity, the computer will immediately
  # take it. no need to evaluate its capture value later.
  PIECE_VALUES = {
    nullpiece: 0,
    pawn: 1,
    knight: 3,
    bishop: 3,
    rook: 5,
    queen: 9
  }

  def get_move(display)
    if display.board.start_pos.nil?
      select_start_pos(display.board)
    else
      select_end_pos(display.board)
    end
  end

  def select_start_pos(board)
    sleep(1)
    # explanation of the following structure: the computer cannot be in
    # checkmate without already being in check. Since #in_check? is
    # a much less expensive operation and a player being in check is not
    # incredibly common, we first evaluate if the player is in check.
    # if not, no reason to run #in_checkmate?. the 'else' on line 56
    # indicates the computer is neither in check nor checkmate. still,
    # though, any move it makes should avoid check, which is why
    # #avoid_check_start_pos is called.
    if board.in_check?(self.color)
      if board.in_checkmate?(self.color)
        random_start_pos(board)
      else
        avoid_check_start_pos(board)
      end
    else
      avoid_check_start_pos(board)
    end
  end

  def possible_start_positions(board)
    start_positions = []

    board.grid.each_with_index do |row, row_idx|
      row.each_index do |col_idx|
        current_pos = [row_idx, col_idx]
        if board.valid_start_pos?(current_pos, self.color)
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
        unless new_board.in_check?(self.color)
          start_positions << start_pos
          # for now we only need start_pos with at least one move that
          # will avoid check. So, for each start_pos, once we confirm
          # there is at least one move to avoid check, we can 'break'.
          break
        end
      end
    end

    induce_check_filter(board, start_positions)
  end

  # this method will take an array of moves and if any of the moves can
  # force the computer's opponent into check/checkmate, it will choose
  # this move.
  def induce_check_filter(board, start_positions)
    filtered_moves = []

    start_positions.each do |start_pos|
      piece = board[start_pos]
      possible_end_positions = piece.moves(board, start_pos)
      possible_end_positions.each do |end_pos|
        new_board = DeepClone.clone(board)
        new_board.move_piece(start_pos, end_pos)
        if new_board.in_checkmate?(opponent_color)
          @end_pos = end_pos
          return start_pos
        elsif new_board.in_check?(opponent_color)
          filtered_moves << start_pos
        end
      end
    end

    moves = filtered_moves.empty? ? start_positions : filtered_moves
    higher_value_capture_filter(board, moves)
  end

  # this method will evaluate if the computer has more than one capture
  # opportunity available. If so, it will capture the piece with the
  # 'highest value', i.e. computer will take a queen over a pawn.
  def higher_value_capture_filter(board, start_positions)
    capture_data = Hash.new { |hash, key| hash[key] = {} }

    start_positions.each do |start_pos|
      piece = board[start_pos]
      possible_end_positions = piece.moves(board, start_pos)
      possible_end_positions.each do |end_pos|
        piece = board[end_pos]
        capture_data[start_pos][end_pos] = piece.type
      end
    end

    highest_value_capture = 0
    highest_value_capture_start_pos = nil
    highest_value_capture_end_pos = nil
    capture_data.each do |start_pos, end_pos_data|
      end_pos_data.each do |end_pos, piece|
        if PIECE_VALUES[piece] >= highest_value_capture
          highest_value_capture = PIECE_VALUES[piece]
          highest_value_capture_start_pos = start_pos
          highest_value_capture_end_pos = end_pos
        end
      end
    end
    @end_pos = highest_value_capture_end_pos
    highest_value_capture_start_pos
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

  def opponent_color
    self.color == :black ? :white : :black
  end
end
